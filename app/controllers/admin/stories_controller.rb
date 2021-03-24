require 'domainatrix'
require 'screen_scraper'
## TODO: not sure why you are requiring the following libraries ?
require 'uri'
require 'socket'
require 'net/http'
require 'net/protocol'

class Admin::StoriesController < Admin::BaseAdminController
  before_action :set_story, only: [:show, :edit, :update, :destroy, :review, :review_update, :update_state]
  before_action :check_for_admin, only: :destroy

  def index
     # database dropdown data
    @locations        = Location.order("ascii(name)")
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)

    @stories = Story.joins(:urls)
    @stories = @stories.where("LOWER(urls.url_title) ~ ?", params[:url_title].downcase) if params[:url_title].present?
    @stories = @stories.where("LOWER(urls.url_desc) ~ ?", params[:url_desc].downcase) if params[:url_desc].present?
    @stories = @stories.where(state: params[:state]) if params[:state].present?
    @stories = @stories.joins(:locations).where(locations: { id: params[:location_id] }) if params[:location_id].present?
    @stories = @stories.joins(:place_categories).where(place_categories: { id: params[:place_category_id] }) if params[:place_category_id].present?
    @stories = @stories.joins(:story_categories).where(story_categories: { id: params[:story_category_id] }) if params[:story_category_id].present?

    if params[:order_by].present?
      col = params[:order_by].split(' ').first
      dir = params[:order_by].split(' ').last
      @stories = @stories.order(col => dir)
    else
      @stories = @stories.order('created_at DESC')
    end

    @pagy, @stories = pagy(@stories)
  end
  
  def scrape
    @story = Story.new
    @screen_scraper = ScreenScraper.new

    @data_entry_begin_time = params[:data_entry_begin_time]
    @source_url_pre        = params[:source_url_pre]

    get_locations_and_categories
    get_domain_info(@source_url_pre)

    if @screen_scraper.scrape!(@full_web_url)
      url = @story.urls.build
      url.images.build
      set_scrape_fields
    else
      flash.now.alert = "We can't find that URL – give it another shot"
      redirect admin_initialize_scraper_index_path
    end
  end

  def create
    # TODO:  check_manual_url(params)
    my_params = set_image_params(story_params)
    @story = Story.new(my_params)

    if @story.save
      update_locations_and_categories(@story, story_params)
      #This script is used to update the permalink field in all stories
      url_title = @story.urls.first.url_title.parameterize
      rand_hex = SecureRandom.hex(2)
      permalink = "#{rand_hex}/#{url_title}"
      @story.update_attribute(:permalink, "#{permalink}")

      redirect_to review_admin_story_path(@story), notice: 'Story was moved to draft mode.'
    else
      @source_url_pre = params["story"]["urls_attributes"]["0"]["url_full"]
      get_domain_info(@source_url_pre)
      set_fields_on_fail(story_params)
      get_locations_and_categories
      render :scrape
    end
  end

  def review
  end

  def review_update
    if @story.update(review_update_params)
      redirect_to review_admin_story_path(@story), notice: 'Story was successfully updated.'
    else
      redirect_to review_admin_story_path(@story), notice: 'Story failed to be updated.'
    end
  end

  def show
    render layout: "application_no_nav"
  end

  def approve
    if @story.approve!
      redirect_to admin_stories_path, notice: "Story has been approved!"
    else
      redirect_to admin_stories_path, alert: "Story has NOT been approved."
    end
  end

  def edit
    # story fields
    @meta_tagline = @story.editor_tagline
    @meta_type    = @story.scraped_type
    @meta_author  = @story.author
    @outside_usa  = @story.outside_usa
    @year         = @story.story_year
    @month        = @story.story_month
    @day          = @story.story_date

    # url fields
    @url1           = @story.urls.first
    @source_url_pre = @url1.url_full
    @base_domain    = @url1.url_domain
    @title          = @url1.url_title
    @meta_desc      = @url1.url_desc
    @meta_keywords  = @url1.url_keywords
    @full_web_url   = @url1.url_full

     # image fields
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
      redirect_to admin_stories_path, notice: 'Story was successfully updated.'
    else
      redirect_to edit_story_path(@story), notice: 'Story failed to be updated.'
    end
  end

  def destroy
    if @story.destroy
      redirect_to admin_stories_path, notice: 'Story was successfully destroyed.'
    else
      redirect_to admin_stories_path, alert: 'Story could not be destroyed.'
    end
  end

  def update_state
    begin
      case params[:state]
      when 'needs_review'
        @story.request_review!
      when 'do_not_publish'
        @story.hide!
      when 'completed'
        @story.complete!
      when 'removed_from_public'
        @story.remove!
      when 'no_status'
        @story.reset!
      end

      redirect_to review_admin_story_path(@story), notice: "Story saved as #{params[:state].titleize}"
    rescue
      redirect_to review_admin_story_path(@story), alert: 'Story failed to update'
    end
  end

  private

  def get_domain_info(source_url_pre)
    full_url = Domainatrix.parse(source_url_pre).url
    sub = Domainatrix.parse(source_url_pre).subdomain
    domain = Domainatrix.parse(source_url_pre).domain
    suffix = Domainatrix.parse(source_url_pre).public_suffix
    prefix = (sub == 'www' || sub == '' ? '' : (sub + '.'))
    @base_domain = prefix + domain + '.' + suffix

    if MediaOwner.where(url_domain: @base_domain).first.present?
      @name_display =  MediaOwner.where(url_domain: @base_domain).first.title
    else
      @name_display = 'NO DOMAIN NAME FOUND'
    end
    @full_web_url = full_url
  end

  private

  def set_story
    begin
      @story = Story.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_stories_path, alert: "Story not found"
    end
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
    @meta_type = hash["story_type"]
    @meta_author = hash["author"]
    @year = hash["story_year"]
    @month = hash["story_month"]
    @day = hash["story_date"]
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
    params.require(:story).permit(
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

  def review_update_params
    params.require(:story).permit(:desc_length)
  end
end
