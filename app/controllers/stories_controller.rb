class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :edit, :update, :destroy]
  require 'rubygems'
  require 'open-uri'
  require 'uri'
  require 'domainatrix'
  require 'nokogiri'
  require 'socket'
  require 'net/http'
  require 'net/protocol'

  def url_show
    @source_url_pre = params[:source_url]  #grab user input
    d_url = Domainatrix.parse(@source_url_pre)
    # dot = "." unless @source_url_pre.nil?
    @domain = d_url.host
    @source_url = @domain
    @full_web_url = d_url.url

    unless @source_url_pre == ""
      display_url
    end
  end

  def display_url
    begin
      doc = Nokogiri::HTML(open(@full_web_url))
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
      para = ""
      doc.css("p").each do |item|
        if item.text.strip.length > 100
          para << item.text.strip
          para << "\n"
        end
      end
      @para = para

      #extract date
      alpha_date_regex = /(?:(?:(?<!\d)(?<a_d1>(?>(?:(?:[23]?1)st|(?:2?2)nd|(?:2?3)rd|(?:[12]?[4-9]|[123]0)th)\b|0[1-9]|[12][0-9]|3[01]|[1-9]|[12][0-9]|3[01]))(?: ?+(?:of )?+))(?>(?<a_m1>jan(?>uary|\.)?|feb(?>ruary|r?\.?)?|mar(?>ch|\.)?|apr(?>il|\.)?|may|jun(?>e|\.)?|jul(?>y|\.)?|aug(?>ust|\.)?|sep(?>tember|t?\.?)?|oct(?>ober|\.)?|nov(?>ember|\.)?|dec(?>ember|\.)?))|(?:\b(?>(?<a_m2>jan(?>uary|\.)?|feb(?>ruary|r?\.?)?|mar(?>ch|\.)?|apr(?>il|\.)?|may|jun(?>e|\.)?|jul(?>y|\.)?|aug(?>ust|\.)?|sep(?>tember|t?\.?)?|oct(?>ober|\.)?|nov(?>ember|\.)?|dec(?>ember|\.)?)))(?:(?:(?: ?+)(?<a_d2>(?>(?:(?:[23]?1)st|(?:2?2)nd|(?:2?3)rd|(?:[12]?[4-9]|[123]0)th)\b|0[1-9]|[12][0-9]|3[01]|[1-9]|[12][0-9]|3[01]))(?!\d))?))(?:(?:,?+)(?:(?:(?: ?)(?<a_y>(?:1[7-9]|20)\d\d|'?+\d\d))(?!\d))|(?<=\b|\.))/
      unless alpha_date_regex.match(doc).nil?
        alpha_date_match = alpha_date_regex.match(doc)
        # @phone_match = alpha_date_match.string #return full string
        @alpha_date_match = alpha_date_match[0].strip
      end
      num_date_regex = /\d{1,2}\/\d{1,2}\/\d{2,4}/
      unless num_date_regex.match(para).nil?
        num_date_match = num_date_regex.match(para)
        @num_date_match = num_date_match[0].strip
      end

      # extract phone number; will be used for places
      # phone_regex = /(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]‌​)\s*)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)([2-9]1[02-9]‌​|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})/
      # unless phone_regex.match(para).nil?
      #   phone_match = phone_regex.match(para)
      #   # @phone_match = phone_match.string #return full string
      #   @phone_match = phone_match[0].strip
      # end

    end
  end

  # GET /stories
  # GET /stories.json
  def index
    @stories = Story.alls
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
  end

  # GET /stories/new
  def new
    @story = Story.new
  end

  # GET /stories/1/edit
  def edit
  end

  # POST /stories
  # POST /stories.json
  def create
    @story = Story.new(story_params)

    respond_to do |format|
      if @story.save
        format.html { redirect_to @story, notice: 'Story was successfully created.' }
        format.json { render :show, status: :created, location: @story }
      else
        format.html { render :new }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stories/1
  # PATCH/PUT /stories/1.json
  def update
    respond_to do |format|
      if @story.update(story_params)
        format.html { redirect_to @story, notice: 'Story was successfully updated.' }
        format.json { render :show, status: :ok, location: @story }
      else
        format.html { render :edit }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.json
  def destroy
    @story.destroy
    respond_to do |format|
      format.html { redirect_to stories_url, notice: 'Story was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_params
      params.require(:story).permit(:url_id, :media_id, :story_type, :author, :publication_date, :source_url)
    end
end
