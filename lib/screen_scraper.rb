require 'open-uri'
require 'nokogiri'
require 'sanitize'
require 'fastimage'

class ScreenScraper
  BROWSER = 'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2049.0 Safari/537.36'
  attr_reader :title, :meta_desc, :meta_type, :meta_keywords, :meta_author, :clean_text, :month, :day, :year, :page_imgs

  def scrape!(scrape_url)
    doc = nil

    begin
      doc = Nokogiri::HTML(open(scrape_url, 'User-Agent' => BROWSER), nil, Encoding::UTF_8.to_s)
      # TODO: handle possible redirection from http --> https
    rescue StandardError # TODO: capture a specific NOKOGIRI exception
      return false
    end

    ## TODO: if something below does not work and you want to scrap the whole thing, just return false
    ##       this class should return true upon success

    # meta title
    @title = doc.at_css('title').content.strip.truncate(250)
    @title = @title == '' ? nil : @title

    # meta description
    meta_desc_scrape_pre = doc.css("meta[name='description']").first
    meta_desc_content = meta_desc_scrape_pre['content'].strip if defined?(meta_desc_scrape_pre['content'])
    if meta_desc_content
      @meta_desc = meta_desc_content.gsub(/\r?\n/, ' ').truncate(995)
    else
      meta_desc_scrape_og_pre = doc.at('meta[property="og:description"]')
      if defined?(meta_desc_scrape_og_pre['content'])
        @meta_desc = meta_desc_scrape_og_pre['content'].strip.gsub(/\r?\n/,
                                                                   ' ').truncate(995)
      end
    end

    # meta type
    meta_type_scrape_og = doc.at('meta[property="og:type"]')
    @meta_type = meta_type_scrape_og['content'].strip if defined?(meta_type_scrape_og['content'])

    # meta keyword
    meta_keywords_scrape_pre = doc.css("meta[name='keywords']").first
    if defined?(meta_keywords_scrape_pre['content'])
      @meta_keywords = meta_keywords_scrape_pre['content'].strip.truncate(995)
    end

    # meta author
    meta_author_scrape_pre = doc.css("meta[name='author']").first
    @meta_author = meta_author_scrape_pre['content'].strip if defined?(meta_author_scrape_pre['content'])
    unless @meta_author
      meta_author_scrape_pre2 = doc.css('a[rel=author]').text
      meta_author_scrape2 = meta_author_scrape_pre2.strip if defined?(meta_author_scrape_pre2)
      @meta_author = meta_author_scrape2
    end

    doc2 = open(scrape_url, 'User-Agent' => BROWSER).read
    clean_text = Sanitize.fragment(doc2, remove_contents: %w[script style])
    @clean_text = clean_text.split.join(' ')

    # extract date
    itemprop_pub_pre = doc.at('meta[itemprop="datePublished"]') # get published date using schema.org format (usatoday, etc.)
    itemprop_pub_date = itemprop_pub_pre['content'].strip if defined?(itemprop_pub_pre['content'])
    itemprop_date_regex = /(?<iyear>\d{4})-(?<imonth>\d{2})-(?<iday>\d{2})/
    itemprop_pub_date_match = itemprop_date_regex.match(itemprop_pub_date)

    alpha_date_match_pos = 0 # try to locate alpha date format
    alpha_date_match = nil
    alpha_month_num = nil
    alpha_date_regex = /(?x)(?i)  # turns on free spacing to allow spaces & comments and turn off case sensitive
                        (?<month>jan(?>uary|\.)?\s|feb(?>ruary|\.)?\s|mar(?>ch|\.)?\s|apr(?>il|\.)?\s|may\s|jun(?>e|\.)?\s|  # process first six months
                        jul(?>y|\.)?\s|aug(?>ust|\.)?\s|sep(?>tember|\.)?\s|oct(?>ober|\.)?\s|nov(?>ember|\.)?\s|dec(?>ember|\.)?\s)  # process second six months
                        (?<day>\d{1,2})?(,|,\s|\s)?  # optional day and separators
                        (?<year>\d{4})/ # four digit year
    unless alpha_date_regex.match(@clean_text).nil?
      alpha_date_match = alpha_date_regex.match(@clean_text)
      alpha_date_match_pos = (alpha_date_regex =~ @clean_text)
      alpha_month = alpha_date_match[:month].strip.downcase
      alpha_month_num = set_alpha_month_num(alpha_month)
    end

    num_date_match_pos = 0 # try to locate number mm/dd/yy or yyyy format
    num_date_match = nil
    num_date_regex = %r{(?<dmonth>\d{1,2})/(?<dday>\d{1,2})/(?<dyear>\d{2,4})}
    unless num_date_regex.match(@clean_text).nil?
      num_date_match = num_date_regex.match(@clean_text)
      num_date_match_pos = (num_date_regex =~ @clean_text)
    end

    if itemprop_pub_date_match.blank?
      unless num_date_match_pos == 0 && alpha_date_match_pos == 0
        set_num_date(num_date_match) if num_date_match_pos != 0 && num_date_match_pos < alpha_date_match_pos
        if alpha_date_match_pos != 0 && num_date_match_pos >= alpha_date_match_pos
          set_alpha_date(alpha_month_num, alpha_date_match)
        end
        set_num_date(num_date_match) if num_date_match_pos != 0 && alpha_date_match_pos == 0
        set_alpha_date(alpha_month_num, alpha_date_match) if num_date_match_pos == 0 && alpha_date_match_pos != 0
      end
    else
      set_itemprop_pub_date(itemprop_pub_date_match)
    end

    # get images
    loop_counter = 0
    found_counter = 0
    @page_imgs = []

    doc.css('img').each do |_i|
      src_url = doc.css('img')[loop_counter]['src'].to_s
      src_url_data_original = doc.css('img')[loop_counter]['data-original'].to_s
      src_url = src_url_data_original if src_url.empty?
      alt_text = doc.css('img')[loop_counter]['alt'].to_s

      if !src_url.empty? && (src_url.match(/(jpg|jpeg|gif|png)/i) && src_url.match(/(http)/i))
        begin
          image_size_array = FastImage.size(src_url, raise_on_failure: true)
          if image_size_array[0].to_i > 199
            # puts "Found counter is: #{found_counter}"
            # puts "src: #{src_url}"
            # puts "alt: #{alt_text}"
            @page_imgs << { 'src_url' => src_url, 'alt_text' => alt_text.capitalize,
                            'image_width' => image_size_array[0], 'image_height' => image_size_array[1] }
            found_counter += 1
          end
        rescue StandardError
          # puts "FastImage error"
        end
      end

      # puts "Loop counter is: #{loop_counter}"
      loop_counter += 1
      break if found_counter > 4 # sets the number of images returned to 5
    end

    true
  end

  private

  def set_alpha_month_num(alpha_month)
    case alpha_month
    when 'jan', 'jan.', 'january'
      1
    when 'feb', 'feb.', 'february'
      2
    when 'mar', 'mar.', 'march'
      3
    when 'apr', 'apr.', 'april'
      4
    when 'may', 'may.'
      5
    when 'jun', 'jun.', 'june'
      6
    when 'jul', 'jul.', 'july'
      7
    when 'aug', 'aug.', 'august'
      8
    when 'sep', 'sep.', 'september'
      9
    when 'oct', 'oct.', 'october'
      10
    when 'nov', 'nov.', 'november'
      11
    when 'dec', 'dec.', 'december'
      12
    else
      99
    end
  end

  def set_itemprop_pub_date(itemprop_pub_date_match)
    # puts "set_itemprop_pub_date"
    @year = itemprop_pub_date_match[:iyear].to_i
    @month = itemprop_pub_date_match[:imonth].to_i
    @day = itemprop_pub_date_match[:iday].to_i
    @day = @day == 0 ? 1 : @day
  end

  def set_num_date(num_date_match)
    # puts "set_num_date"
    @month = num_date_match[:dmonth].to_i
    @day = num_date_match[:dday].to_i
    @day = @day == 0 ? 1 : @day
    @year = num_date_match[:dyear].to_i
  end

  def set_alpha_date(alpha_month_num, alpha_date_match)
    # puts "set_alpha_date"
    @month = alpha_month_num.to_i
    @day = alpha_date_match[:day].to_i
    @day = @day == 0 ? 1 : @day
    @year = alpha_date_match[:year].to_i
  end
end
