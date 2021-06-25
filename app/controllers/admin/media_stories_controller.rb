require 'domainatrix'
require 'screen_scraper'
## TODO: not sure why you are requiring the following libraries ?
require 'uri'
require 'socket'
require 'net/http'
require 'net/protocol'

class Admin::MediaStoriesController < Admin::BaseAdminController
  before_action :set_media_story, only: %i[edit update]

  def scrape
    @story = MediaStory.new
    @screen_scraper = ScreenScraper.new
    @data_entry_begin_time = params[:data_entry_begin_time]
    get_locations_and_categories
    get_domain_info(params[:source_url_pre])

    if @screen_scraper.scrape!(params[:source_url_pre])
      url = @story.urls.build
      url.url_full = params[:source_url_pre]
      set_scrape_fields
    else
      flash.now.alert = "We can't find that URL – give it another shot"
      redirect_to admin_initialize_scraper_index_path
    end
  end

  def create
    @story = MediaStory.new(story_params)
    if @story.save
      # Update the permalink field.
      @story.create_permalink
      update_locations_places_and_categories(@story, story_params)
      redirect_to redirect_to_next_path(images_admin_story_path(@story)), notice: 'Story was saved.'
    else
      get_domain_info(@story.urls.last.url_full)
      get_locations_and_categories
      render :scrape
    end
  end

  def edit
    # image fields
    @url1 = @story.urls.first
    get_locations_places_and_categories
    # media_owner stuff
    get_domain_info(@story.urls.last.url_full)

    # complete checks
    @tagline_complete = @story.editor_tagline.present?
    @date_complete    = @story.story_year.present? || @story.story_month.present? || @story.story_date.present?
    @story_complete   = @story.story_complete
    @title_complete   = @url1.url_title.present?
    @desc_complete    = @url1.url_desc.present?
  end

  def update
    if @story.update(story_params)
      update_locations_places_and_categories(@story, story_params)
      redirect_to redirect_to_next_path(images_admin_story_path(@story)), notice: 'Story was successfully updated.'
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
    prefix     = ['www', ''].include?(subdomain) ? '' : (subdomain + '.')
    @base_domain = prefix + domain + '.' + suffix

    @name_display = if MediaOwner.where(url_domain: @base_domain).first.present?
                      MediaOwner.where(url_domain: @base_domain).first.title
                    else
                      'NO DOMAIN NAME FOUND'
                    end
  end

  def set_media_story
    @story = MediaStory.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_stories_path, alert: 'Story not found'
  end

  def set_scrape_fields
    @story.story_type = @screen_scraper.meta_type
    @story.author = @screen_scraper.meta_author
    @story.story_year = @screen_scraper.year
    @story.story_month = @screen_scraper.month
    @story.story_date = @screen_scraper.day

    url = @story.urls.last
    url.url_title = @screen_scraper.title
    url.url_desc = @screen_scraper.meta_desc
    url.url_keywords = @screen_scraper.meta_keywords
  end

  def get_locations_places_and_categories
    @locations = Location.order(:name)
    @places = Place.order(:name)
    @story_categories = StoryCategory.order(:name)
    @place_categories = PlaceCategory.order(:name)
  end


  def update_locations_places_and_categories(story, my_params)
    new_locations = Location.find(process_chosen_params(my_params[:location_ids]))
    story.locations = new_locations

    new_places = Place.find(process_chosen_params(my_params[:place_ids]))
    story.places = new_places

    new_story_categories = StoryCategory.find(process_chosen_params(my_params[:story_category_ids]))
    story.story_categories = new_story_categories

    new_place_categories = PlaceCategory.find(process_chosen_params(my_params[:place_category_ids]))
    story.place_categories = new_place_categories
  end

  def process_chosen_params(my_params)
    my_params.reject { |p| p.empty? }.map { |p| p.to_i } if my_params.present?
  end

  def story_params
    params.require(:media_story).permit(
      :media_id, :scraped_type, :story_type, :author, :outside_usa, :story_year, :story_month, :story_date, :sap_publish_date,
      :editor_tagline, :raw_author_scrape, :raw_story_year_scrape,
      :raw_story_month_scrape, :raw_story_date_scrape, :data_entry_begin_time, :data_entry_user, :story_complete,
      :release_seq, :state, :desc_length,
      location_ids: [],
      place_ids: [],
      place_category_ids: [],
      story_category_ids: [],
      urls_attributes: [
        :id, :url_type, :url_full, :url_title, :url_desc, :url_keywords, :url_domain, :primary, :story_id,
        :url_title_track, :url_desc_track, :url_keywords_track,
        :raw_url_title_scrape, :raw_url_desc_scrape, :raw_url_keywords_scrape,
        { images_attributes: %i[id src_url alt_text image_data manual_url image_width image_height manual_enter] }
      ]
    )
  end

  def redirect_to_next_path(path)
    if params[:commit] == 'Save & New'
      admin_initialize_scraper_index_path
    elsif params[:commit] == 'Save & Exit'
      admin_stories_path
    else
      path
    end
  end
end
