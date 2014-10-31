require 'domainatrix'
require 'screen_scraper'
## TODO: not sure why you are requiring the following libraries ?
require 'uri'
require 'socket'
require 'net/http'
require 'net/protocol'

class StoriesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_story, only: [:show, :edit, :update, :destroy]

  def scrape
  end

  # GET /stories
  # GET /stories.json
  def index
    @stories = Story.order("id DESC").all
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
    @story = Story.find(params[:id])
    @urls = @story.urls
    @images = @urls.first.images
  end

  # GET /stories/new
  def new
    # parse the domain
    @data_entry_begin_time = params[:data_entry_begin_time]  #grab user input
    @source_url_pre = params[:source_url_pre]  #grab user input
    if @source_url_pre.present?
      get_domain_info(@source_url_pre)
      @screen_scraper = ScreenScraper.new
      if @screen_scraper.scrape!(@full_web_url)
        @story = Story.new
        url = @story.urls.build
        url.images.build
        set_scrape_fields
      else
        flash.now.alert = "We can't find that URL – give it another shot"
        render :scrape
      end
    else
      flash.now.alert = "You have to enter a URL for this to work"
      render :scrape
    end
  end

  # POST /stories
  # POST /stories.json
  def create
    # TODO:  check_manual_url(params)
    my_params = set_image_params(story_params)
    # @data_entry_begin_time = data_entry_begin_time(story_params)
    @story = Story.new(my_params)

    respond_to do |format|
      if @story.save
        format.html { redirect_to @story, notice: 'Story was successfully created.' }
        format.json { render :show, status: :created, location: @story }
      else
        @source_url_pre = params["story"]["urls_attributes"]["0"]["url_full"]
        get_domain_info(@source_url_pre)
        set_fields_on_fail(story_params)
        format.html { render :new }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /stories/1/edit
  def edit
    @story = Story.find(params[:id])
    @previous = Story.where("id < ?", params[:id]).order(:id).last
    @next = Story.where("id > ?", params[:id]).order(:id).first
    @meta_tagline = @story.editor_tagline  # story fields
    @meta_location = @story.location_code
    @meta_place = @story.place_category
    @meta_story_category = @story.story_category
    @meta_type = @story.scraped_type
    @meta_author = @story.author
    @year = @story.story_year
    @month = @story.story_month
    @day = @story.story_date

    @url1 = @story.urls.first  # url fields
    @source_url_pre = @url1.url_full
    @base_domain = @url1.url_domain
    @title = @url1.url_title
    @meta_desc = @url1.url_desc
    @meta_keywords = @url1.url_keywords
    @full_web_url = @url1.url_full

    @image1 = @url1.images.first  # image fields
    @page_imgs = [{'src_url' => @image1.src_url, 'alt_text' => @image1.alt_text, 'image_width' => @image1.image_width, 'image_height' => @image1.image_height}]
  end

  # PATCH/PUT /stories/1
  # PATCH/PUT /stories/1.json
  def update
    respond_to do |format|
      # TODO: if you have params[:manual_url], you may need to get out and verify the image exists
      #       if it does not exist return an error
      #       if it does exist, get the src_url and alt_text and nest them into story_params properly
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

  def get_domain_info(source_url_pre)
    d_url = Domainatrix.parse(source_url_pre)
    @full_domain = d_url.host
    split_full_domain = @full_domain.split(".")
    if split_full_domain.length == 2
      @base_domain = split_full_domain[0].to_s + "." + split_full_domain[1].to_s
    else
      @base_domain = split_full_domain[1].to_s + "." + split_full_domain[2].to_s
    end
    @full_web_url = d_url.url
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_story
    @story = Story.find(params[:id])
  end

  def set_scrape_fields
    @title = @screen_scraper.title
    @meta_desc = @screen_scraper.meta_desc
    @meta_keywords = @screen_scraper.meta_keywords
    @meta_type = @screen_scraper.meta_type
    @meta_author = @screen_scraper.meta_author
    @year = @screen_scraper.year
    @month = @screen_scraper.month
    @day = @screen_scraper.day
    @page_imgs = @screen_scraper.page_imgs

    @itemprop_pub_date_match

  end

  def set_fields_on_fail(hash)
    @title = hash['urls_attributes']['0']['url_title']
    @meta_desc = hash['urls_attributes']['0']['url_desc']
    @meta_keywords = hash['urls_attributes']['0']['url_keywords']
    @meta_tagline = hash["editor_tagline"]
    @meta_location = hash["location_code"]
    @meta_place = hash["place_category"]
    @meta_story_category = hash["story_category"]
    @meta_type = hash["story_type"]
    @meta_author = hash["author"]
    @year = hash["story_year"]
    @month = hash["story_month"]
    @day = hash["story_date"]
    @page_imgs = []
    params['image_src_cache'].try(:each) do |key, src_url|  # in case hidden field hash is nil, added try
      @page_imgs << { 'src_url' => src_url, 'alt_text' => params['image_alt_text_cache'][key] }
    end
  end

  def set_image_params(story_params)
    image_data = story_params["urls_attributes"]["0"]["images_attributes"]["0"]["image_data"]
    unless image_data.nil?
      image_data_hash = JSON.parse(image_data)
      story_params["urls_attributes"]["0"]["images_attributes"]["0"]["src_url"] = image_data_hash["src_url"]
      story_params["urls_attributes"]["0"]["images_attributes"]["0"]["alt_text"]= image_data_hash["alt_text"]
      story_params["urls_attributes"]["0"]["images_attributes"]["0"]["image_width"] = image_data_hash["image_width"]
      story_params["urls_attributes"]["0"]["images_attributes"]["0"]["image_height"]= image_data_hash["image_height"]
    end
    story_params
    # binding.pry
  end

  def schedule_story
    stories_per_day = Code.where("code_key = 'STORIES_PER_DAY'").pluck("code_value")
    stories_every_n_secs = 60 * 60 * 24 / stories_per_day
    next_story_to_publish = Story.order("created_at").where("sap_publish_date is null").pluck("id").first

  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def story_params
    params.require(:story).permit(
      :media_id, :scraped_type, :story_type, :author, :story_month, :story_date, :sap_publish_date, :story_year,
      :editor_tagline, :location_code, :place_category, :story_category, :raw_author_scrape, :raw_story_year_scrape,
      :raw_story_month_scrape, :raw_story_date_scrape, :data_entry_begin_time,
      urls_attributes: [
        :id, :url_type, :url_full, :url_title, :url_desc, :url_keywords, :url_domain, :primary, :story_id,
        :url_title_track, :url_desc_track, :url_keywords_track,
        :raw_url_title_scrape, :raw_url_desc_scrape, :raw_url_keywords_scrape,
            images_attributes: [:id, :src_url, :alt_text, :image_data, :manual_url, :image_width, :image_height, :manual_enter]])
  end

end
