class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def display_url
    begin
      browser = 'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2049.0 Safari/537.36'
      doc = Nokogiri::HTML(open(@full_web_url, 'User-Agent' => browser))
    rescue
      return nil
    else

      meta_desc_scrape_pre = doc.css("meta[name='description']").first
      @meta_desc_scrape = meta_desc_scrape_pre['content'] if defined?(meta_desc_scrape_pre['content'])
      @title_scrape = doc.at_css('title').content
      meta_keyword_scrape_pre = doc.css("meta[name='keywords']").first
      @meta_keyword_scrape = meta_keyword_scrape_pre['content'] if defined?(meta_keyword_scrape_pre['content'])
      meta_author_scrape_pre = doc.css("meta[name='author']").first
      @meta_author_scrape = meta_author_scrape_pre['content'] if defined?(meta_author_scrape_pre['content'])

      # paragraph search
      # para = ""
      # doc.css("p").each do |item|
      #   if item.text.strip.length > 100
      #     para << item.text.strip
      #     para << "\n"
      #   end
      # end
      # @para = para

      doc2 = open(@full_web_url, 'User-Agent' => browser).read
      clean_text = Sanitize.fragment(doc2, :remove_contents => ['script', 'style'])
      @clean_text = clean_text.split.join(" ")

      #extract date
      @alpha_date_match_pos = 0  # initialize
      alpha_date_regex = /(?x)(?i)  # turn on free spacing to allow spaces & comments and turn off case sensitive
                          (?<month>jan(?>uary|\.)?\s|feb(?>ruary|\.)?\s|mar(?>ch|\.)?\s|apr(?>il|\.)?\s|may\s|jun(?>e|\.)?\s|  # first six months
                          jul(?>y|\.)?\s|aug(?>ust|\.)?\s|sep(?>tember|\.)?\s|oct(?>ober|\.)?\s|nov(?>ember|\.)?\s|dec(?>ember|\.)?\s)  # second six months
                          (?<day>\d{1,2})?(,|,\s|\s)?  # optional day and separators
                          (?<year>\d{4})/  # four digit year
      unless alpha_date_regex.match(@clean_text).nil?
        @alpha_date_match = alpha_date_regex.match(@clean_text)
        @alpha_date_match_pos = alpha_date_regex =~ @clean_text
        # @alpha_date_match_pos ||= 0
        alpha_month = @alpha_date_match[:month].strip.downcase
        case alpha_month
          when 'jan','january'
           @alpha_month_num = '1'
          when 'feb','february'
           @alpha_month_num = '2'
          when 'mar','march'
           @alpha_month_num = '3'
          when 'apr','april'
           @alpha_month_num = '4'
          when 'may'
           @alpha_month_num = '5'
          when 'jun','june'
           @alpha_month_num = '6'
          when 'jul','july'
           @alpha_month_num = '7'
          when 'aug','august'
           @alpha_month_num = '8'
          when 'sep','september'
           @alpha_month_num = '9'
          when 'oct','october'
           @alpha_month_num = '10'
          when 'nov','november'
           @alpha_month_num = '11'
          when 'dec','december'
           @alpha_month_num = '12'
          else
           @alpha_month_num = '99'
        end
      end

      @num_date_match_pos = 0
      num_date_regex = /(?<dmonth>\d{1,2})\/(?<dday>\d{1,2})\/(?<dyear>\d{2,4})/
      unless num_date_regex.match(@clean_text).nil?
        num_date_match = num_date_regex.match(@clean_text)
        @num_date_match_pos = num_date_regex =~ @clean_text
        # @num_date_match_pos ||= 1
        @num_date_match = num_date_match[0].strip
      end

      unless @num_date_match_pos == 0 && @alpha_date_match_pos == 0
        if @num_date_match_pos != 0 && @num_date_match_pos < @alpha_date_match_pos
          # flash[:error] = "N1 alpha_month_num is \n #{alpha_month_num}"
          set_num_date
        end
        if @alpha_date_match_pos != 0 && @num_date_match_pos >= @alpha_date_match_pos
          # flash[:error] = "A1 alpha_month_num is \n #{alpha_month_num}"
          set_alpha_date
        end
        if @num_date_match_pos != 0 && @alpha_date_match_pos == 0
          # flash[:error] = "N1 alpha_month_num is \n #{alpha_month_num}"
          set_num_date
        end
        if @num_date_match_pos == 0 && @alpha_date_match_pos != 0
          # flash[:error] = "A1 alpha_month_num is \n #{alpha_month_num}"
          set_alpha_date
        end

      end
    end
  end

  def set_num_date
    @month = num_date_match[:dmonth]
    @day = num_date_match[:dday]
    @year = num_date_match[:dyear]
  end

  def set_alpha_date
    @month = @alpha_month_num
    @day = @alpha_date_match[:day]
    @year = @alpha_date_match[:year]
  end

  # extract phone number; will be used for places
  # phone_regex = /(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]‌​)\s*)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)([2-9]1[02-9]‌​|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})/
  # unless phone_regex.match(para).nil?
  #   phone_match = phone_regex.match(para)
  #   # @phone_match = phone_match.string #return full string
  #   @phone_match = phone_match[0].strip
  # end

  private

  def allow_iframe
    response.headers.delete "X-Frame-Options"
  end

end
