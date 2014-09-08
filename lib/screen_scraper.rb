require 'open-uri'
require 'nokogiri'
require 'sanitize'

class ScreenScraper

  BROWSER = 'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2049.0 Safari/537.36'
  attr_reader :title, :meta_desc, :meta_type, :meta_keywords, :meta_author, :clean_text, :month, :day, :year

  def scrape!(scrape_url)

    doc = nil
    begin
      doc = Nokogiri::HTML(open(scrape_url, 'User-Agent' => BROWSER))
      # TODO: handle possible redirection from http --> https
    rescue # TODO: catpure a sepcific NOKOGIRI exception
      return false
    end

    ## TODO: if something below does not work and you want to scrap the whole thing, just return false
    ##       this class should return true upon success

    # meta title
    @title = doc.at_css('title').content.strip

    # meta description
    meta_desc_scrape_pre = doc.css("meta[name='description']").first
    meta_desc_content = meta_desc_scrape_pre['content'].strip if defined?(meta_desc_scrape_pre['content'])
    if meta_desc_content
      @meta_desc = meta_desc_content
    else
      meta_desc_scrape_og_pre = doc.at('meta[property="og:description"]')
      @meta_desc = meta_desc_scrape_og_pre['content'].strip if defined?(meta_desc_scrape_og_pre['content'])
    end

    # meta type
    meta_type_scrape_og = doc.at('meta[property="og:type"]')
    @meta_type = meta_type_scrape_og['content'].strip if defined?(meta_type_scrape_og['content'])

    # meta keyword
    meta_keywords_scrape_pre = doc.css("meta[name='keywords']").first
    @meta_keywords = meta_keywords_scrape_pre['content'].strip if defined?(meta_keywords_scrape_pre['content'])

    # meta author
    meta_author_scrape_pre = doc.css("meta[name='author']").first
    @meta_author = meta_author_scrape_pre['content'].strip if defined?(meta_author_scrape_pre['content'])
    unless @meta_author
      meta_author_scrape_pre2 = doc.css('a[rel=author]').text
      meta_author_scrape2 = meta_author_scrape_pre2.strip if defined?(meta_author_scrape_pre2)
      @meta_author = meta_author_scrape2
    end

    # paragraph search
    # para = ""
    # doc.css("p").each do |item|
    #   if item.text.strip.length > 100
    #     para << item.text.strip
    #     para << "\n"
    #   end
    # end
    # @para = para

    doc2 = open(scrape_url, 'User-Agent' => BROWSER).read
    clean_text = Sanitize.fragment(doc2, :remove_contents => ['script', 'style'])
    @clean_text = clean_text.split.join(" ")

    # extract date
    alpha_date_match_pos = 0  # initialize
    alpha_date_match = nil
    alpha_month_num = nil
    alpha_date_regex = /(?x)(?i)  # turn on free spacing to allow spaces & comments and turn off case sensitive
                        (?<month>jan(?>uary|\.)?\s|feb(?>ruary|\.)?\s|mar(?>ch|\.)?\s|apr(?>il|\.)?\s|may\s|jun(?>e|\.)?\s|  # first six months
                        jul(?>y|\.)?\s|aug(?>ust|\.)?\s|sep(?>tember|\.)?\s|oct(?>ober|\.)?\s|nov(?>ember|\.)?\s|dec(?>ember|\.)?\s)  # second six months
                        (?<day>\d{1,2})?(,|,\s|\s)?  # optional day and separators
                        (?<year>\d{4})/  # four digit year
    unless alpha_date_regex.match(@clean_text).nil?
      alpha_date_match = alpha_date_regex.match(@clean_text)
      alpha_date_match_pos = (alpha_date_regex =~ @clean_text)
      alpha_month = alpha_date_match[:month].strip.downcase
      alpha_month_num = set_alpha_month(alpha_month)
    end

    num_date_match_pos = 0
    num_date_match = nil
    num_date_regex = /(?<dmonth>\d{1,2})\/(?<dday>\d{1,2})\/(?<dyear>\d{2,4})/
    unless num_date_regex.match(@clean_text).nil?
      num_date_match = num_date_regex.match(@clean_text)
      num_date_match_pos = (num_date_regex =~ @clean_text)
      num_date_match = num_date_match[0].strip
    end

    unless num_date_match_pos == 0 && alpha_date_match_pos == 0
      if num_date_match_pos != 0 && num_date_match_pos < alpha_date_match_pos
        set_num_date(num_date_match)
      end
      if alpha_date_match_pos != 0 && num_date_match_pos >= alpha_date_match_pos
        set_alpha_date(alpha_month_num, alpha_date_match)
      end
      if num_date_match_pos != 0 && alpha_date_match_pos == 0
        set_num_date(num_date_match)
      end
      if num_date_match_pos == 0 && alpha_date_match_pos != 0
        set_alpha_date(alpha_date_num, alpha_date_match)
      end
    end

    return true
  end

  private

  def set_alpha_month_num(alpha_month)
    case alpha_month
      when 'jan','january'
       '1'
      when 'feb','february'
       '2'
      when 'mar','march'
       '3'
      when 'apr','april'
       '4'
      when 'may'
       '5'
      when 'jun','june'
       '6'
      when 'jul','july'
       '7'
      when 'aug','august'
       '8'
      when 'sep','september'
       '9'
      when 'oct','october'
       '10'
      when 'nov','november'
       '11'
      when 'dec','december'
       '12'
      else
       '99'
    end
  end

  def set_num_date(num_date_match)
    @month = num_date_match[:dmonth]
    @day = num_date_match[:dday]
    @year = num_date_match[:dyear]
  end

  def set_alpha_date(alpha_month_num, alpha_date_match)
    @month = alpha_month_num
    @day = alpha_date_match[:day]
    @year = alpha_date_match[:year]
  end

  # extract phone number; will be used for places
  # phone_regex = /(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]‌​)\s*)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)([2-9]1[02-9]‌​|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})/
  # unless phone_regex.match(para).nil?
  #   phone_match = phone_regex.match(para)
  #   # @phone_match = phone_match.string #return full string
  #   @phone_match = phone_match[0].strip
  # end

end