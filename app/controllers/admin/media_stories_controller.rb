require 'domainatrix'
require 'screen_scraper'
## TODO: not sure why you are requiring the following libraries ?
require 'uri'
require 'socket'
require 'net/http'
require 'net/protocol'

class Admin::MediaStoriesController < Admin::BaseAdminController
  before_action :set_media_story, only: [:edit, :update]

  def scrape
    @story = MediaStory.new
    @screen_scraper = ScreenScraper.new
    @data_entry_begin_time = params[:data_entry_begin_time]
    get_locations_and_categories
    get_domain_info(params[:source_url_pre])

    if @screen_scraper.scrape!(params[:source_url_pre])
      url = @story.urls.build
      url.url_full = params[:source_url_pre]
      url.images.build
      set_scrape_fields
    else
      flash.now.alert = "We can't find that URL – give it another shot"
      redirect_to admin_initialize_scraper_index_path
    end
  end

  def create
    # TODO:  check_manual_url(params)
    my_params = set_image_params(story_params)
    @story = MediaStory.new(my_params)
    if @story.save
      #Update the permalink field.
      @story.create_permalink
      update_locations_and_categories(@story, story_params)
      redirect_to review_admin_story_path(@story), notice: 'Story was saved.'
    else
      get_domain_info(@story.urls.last.url_full)
      set_fields_on_fail(story_params)
      get_locations_and_categories
      render :scrape
    end
  end

  def edit
    # story fields
    @year         = @story.story_year
    @month        = @story.story_month
    @day          = @story.story_date

     # image fields
    @url1 = @story.urls.first
    @image1    = @url1.images.first
    @page_imgs = [{
      'src_url' => @image1.src_url,
      'alt_text' => @image1.alt_text,
      'image_width' => @image1.image_width,
      'image_height' => @image1.image_height
    }]

    # locations and categories
    get_locations_and_categories
    @selected_location_ids       = @story.locations.pluck(:id)
    @selected_place_category_ids = @story.place_categories.pluck(:id)
    @selected_story_category_ids = @story.story_categories.pluck(:id)

    # media_owner stuff
    media_owner   = MediaOwner.where(url_domain: @base_domain).first
    @name_display = media_owner&.title || 'NO DOMAIN NAME FOUND'

    # complete checks
    @title_complete   = @title.present?
    @tagline_complete = @meta_tagline.present?
    @desc_complete    = @meta_desc.present?
    @date_complete    = @year.present? || @month.present? || @day.present?
    @story_complete   = @story.story_complete
    @pc_complete      = @selected_place_category_ids.present?
  end

  def update
    if @story.update(story_params)
      update_locations_and_categories(@story, story_params)
      redirect_to admin_stories_path, notice: 'Story was successfully updated.'
    else
      redirect_to edit_media_story_path(@story), notice: 'Story failed to be updated.'
    end
  end

  private

  def get_domain_info(source_url_pre)
    parsed_url = Domainatrix.parse(source_url_pre)
    full_url   = parsed_url.url
    subdomain  = parsed_url.subdomain
    domain     = parsed_url.domain
    suffix     = parsed_url.public_suffix
    prefix     = (subdomain == 'www' || subdomain == '') ? '' : (subdomain + '.')
    @base_domain = prefix + domain + '.' + suffix

    if MediaOwner.where(url_domain: @base_domain).first.present?
      @name_display = MediaOwner.where(url_domain: @base_domain).first.title
    else
      @name_display = 'NO DOMAIN NAME FOUND'
    end
  end

  def set_media_story
    begin
      @story = MediaStory.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_stories_path, alert: "Story not found"
    end
  end

  def set_scrape_fields
    @story.story_type = @screen_scraper.meta_type
    @story.author = @screen_scraper.meta_author
    @story.story_year = @screen_scraper.year
    @story.story_month = @screen_scraper.month
    @story.story_date = @screen_scraper.day

    url = @story.urls.last
    url.url_title  = @screen_scraper.title
    url.url_desc  = @screen_scraper.meta_desc
    url.url_keywords = @screen_scraper.meta_keywords

    @page_imgs = @screen_scraper.page_imgs
  end

  def set_fields_on_fail(hash)
    @page_imgs = []
    params['image_src_cache'].try(:each) do |key, src_url|  # in case hidden field hash is nil, added try
      @page_imgs << { 'src_url' => src_url, 'alt_text' => params['image_alt_text_cache'][key] }
    end
    @selected_location_ids = process_chosen_params(hash['location_ids'])
    @selected_place_category_ids = process_chosen_params(hash['place_category_ids'])
    @selected_story_category_ids = process_chosen_params(hash['story_category_ids'])
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
  end

  def get_locations_and_categories
    @locations = Location.order(:name)
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)
  end

  def update_locations_and_categories(story, my_params)
    new_locations = Location.find(process_chosen_params(my_params[:location_ids]))
    story.locations = new_locations

    new_place_categories = PlaceCategory.find(process_chosen_params(my_params[:place_category_ids]))
    story.place_categories = new_place_categories

    new_story_categories = StoryCategory.find(process_chosen_params(my_params[:story_category_ids]))
    story.story_categories = new_story_categories
  end

  def process_chosen_params(my_params)
    if my_params.present?
      my_params.reject{|p| p.empty?}.map{|p| p.to_i}
    end
  end

  def story_params
    params.require(:media_story).permit(
      :media_id, :scraped_type, :story_type, :author, :outside_usa, :story_year, :story_month, :story_date, :sap_publish_date,
      :editor_tagline, :raw_author_scrape, :raw_story_year_scrape,
      :raw_story_month_scrape, :raw_story_date_scrape, :data_entry_begin_time, :data_entry_user, :story_complete,
      :release_seq, :state, :desc_length,
      :location_ids => [],
      :place_category_ids => [],
      :story_category_ids => [],
      urls_attributes: [
        :id, :url_type, :url_full, :url_title, :url_desc, :url_keywords, :url_domain, :primary, :story_id,
        :url_title_track, :url_desc_track, :url_keywords_track,
        :raw_url_title_scrape, :raw_url_desc_scrape, :raw_url_keywords_scrape,
            images_attributes: [:id, :src_url, :alt_text, :image_data, :manual_url, :image_width, :image_height, :manual_enter]])
  end
end
