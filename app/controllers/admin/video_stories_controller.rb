require 'video_scraper'

class Admin::VideoStoriesController < Admin::BaseAdminController
  before_action :get_locations_and_categories, only: [:index, :new, :scrape, :edit]
  before_action :set_video_story, only: [:show, :edit, :update, :destroy, :review, :review_update, :update_state]

  def index
    @video_stories = VideoStory.all

    @video_stories = @video_stories.where("LOWER(description) ~ ?", params[:description].downcase) if params[:description].present?
    @video_stories = @video_stories.where("LOWER(title) ~ ?", params[:title].downcase) if params[:title].present?
    @video_stories = @video_stories.where('state = ?', params[:state]) if params[:state].present?
    @video_stories = @video_stories.joins(:locations).where("locations.id = ?", params[:location_id]) if params[:location_id].present?
    @video_stories = @video_stories.joins(:place_categories).where("place_categories.id = ?", params[:place_category_id]) if params[:place_category_id].present?
    @video_stories = @video_stories.joins(:story_categories).where("story_categories.id = ?", params[:story_category_id]) if params[:story_category_id].present?

    @pagy, @video_stories = pagy(@video_stories)
  end

  def scrape
    @data_entry_begin_time = params[:data_entry_begin_time]
    @source_url_pre        = params[:source_url_pre]
    get_domain_info(@source_url_pre)

    @video_story = VideoStory.new
    @video_story.video_url = @full_web_url

    @screen_scraper = VideoScraper.new
    if @screen_scraper.scrape!(@full_web_url)
      set_scrape_fields
    else
      flash.now.alert = "Something went wrong with the scraper."
      redirect admin_initialize_scraper_index_path
    end
  end

  def create
    @video_story = VideoStory.new(video_story_params)
    @video_story.video_duration = set_duration(params[:video_story])
    if @video_story.save
      update_locations_and_categories(@video_story, video_story_params)
      redirect_to review_admin_video_story_path(@video_story), notice: 'Story was moved to draft mode.'
    else
      get_domain_info(@source_url_pre)
      set_fields_on_fail(video_story_params)
      get_locations_and_categories
      render :scrape
    end
  end

  def review
  end

  def review_update
    if @video_story.update(review_update_params)
      redirect_to review_admin_video_story_path(@video_story), notice: 'Story was successfully updated.'
    else
      redirect_to review_admin_video_story_path(@video_story), notice: 'Story failed to be updated.'
    end
  end

  def show
    render layout: "application_no_nav"
  end

  def approve
    if @video_story.approve!
      redirect_to admin_video_stories_path, notice: "Video Story has been approved!"
    else
      redirect_to admin_video_stories_path, alert: "Video Story has NOT been approved."
    end
  end

  def edit
    # story fields
    @meta_tagline     = @video_story.editor_tagline
    @link_creator     = @video_story.video_creator
    @outside_usa      = @video_story.outside_usa
    @year             = @video_story.story_year
    @month            = @video_story.story_month
    @day              = @video_story.story_date
    @link_channel_id  = @video_story.channel_id
    @meta_views       = @video_story.views
    @meta_likes       = @video_story.likes
    @meta_dislikes    = @video_story.dislikes
    @meta_subscribers = @video_story.subscribers
    @unlisted         = @video_story.unlisted
    @hashtags         = @video_story.hashtags
    @video_hashtags   = @video_story.video_hashtags
    @base_domain      = @video_story.video_url
    @title            = @video_story.title
    @meta_desc        = @video_story.description
    @meta_keywords    = @video_story.url_keywords
    @link_image       = @video_story.thumbnail_url

    # locations and categories
    get_locations_and_categories
    @selected_location_ids       = @video_story.locations.pluck(:id)
    @selected_place_category_ids = @video_story.place_categories.pluck(:id)
    @selected_story_category_ids = @video_story.story_categories.pluck(:id)
    get_time(@video_story.video_duration)
  end

  def update
    @video_story.video_duration = set_duration(params[:video_story])

    if @video_story.update(video_story_params)
      redirect_to admin_video_stories_path, notice: 'Story was successfully updated.'
    else
      redirect_to edit_admin_video_story_path(@video_story), notice: 'Story failed to be updated.'
    end
  end

  def destroy
    if @video_story.destroy
      redirect_to admin_video_stories_path, notice: 'Story was successfully destroyed.'
    else
      redirect_to admin_video_stories_path, alert: 'Story could not be destroyed.'
    end
  end

  def update_state
    begin
      case params[:state]
      when 'needs_review'
        @video_story.request_review!
      when 'do_not_publish'
        @video_story.hide!
      when 'completed'
        @video_story.complete!
      when 'removed_from_public'
        @video_story.remove!
      when 'no_status'
        @video_story.reset!
      end

      redirect_to review_admin_video_story_path(@video_story), notice: "Video Story saved as #{params[:state].titleize}"
    rescue
      redirect_to review_admin_video_story_path(@video_story), alert: 'Video Story failed to update'
    end
  end

  private

  def set_scrape_fields
    @title            = @screen_scraper.title
    @meta_desc        = @screen_scraper.meta_desc
    @link_creator     = @screen_scraper.link_creator
    @link_channel_id  = @screen_scraper.link_channel_id
    @link_image       = @screen_scraper.link_image
    @meta_keywords    = @screen_scraper.meta_keywords
    @meta_type        = @screen_scraper.meta_type
    @meta_author      = @screen_scraper.meta_author
    @year             = @screen_scraper.year
    @month            = @screen_scraper.month
    @day              = @screen_scraper.day
    @page_imgs        = @screen_scraper.page_imgs

    @itemprop_pub_date_match
  end

  def set_video_story
    begin
      @video_story = VideoStory.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_stories_path, alert: "Video Story not found"
    end
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

  def get_locations_and_categories
    @locations        = Location.order("ascii(name)")
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)
  end

  def get_domain_info(source_url_pre)
    full_url      = Domainatrix.parse(source_url_pre).url
    sub           = Domainatrix.parse(source_url_pre).subdomain
    domain        = Domainatrix.parse(source_url_pre).domain
    suffix        = Domainatrix.parse(source_url_pre).public_suffix
    prefix        = (sub == 'www' || sub == '' ? '' : (sub + '.'))
    @base_domain  = prefix + domain + '.' + suffix
    @full_web_url = full_url
  end

  def video_story_params
    params.require(:video_story).permit(
      :video_url,
      :editor_tagline, :hashtags, :video_creator, :channel_id,
      :views, :subscribers, :likes, :dislikes, :unlisted,
      :video_duration, :video_hashtags, :outside_usa, :state,
      :story_year, :story_month, :story_date, :thumbnail_url,
      :data_entry_begin_time, :data_entry_user, :desc_length,
      :location_ids => [],
      :place_category_ids => [],
      :story_category_ids => [],
      urls_attributes: [
        :id, :url_type, :url_full, :url_title, :url_desc, :url_keywords, :url_domain, :primary, :story_id,
        :url_title_track, :url_desc_track, :url_keywords_track,
        :raw_url_title_scrape, :raw_url_desc_scrape, :raw_url_keywords_scrape,
            images_attributes: [:id, :src_url, :alt_text, :image_data, :manual_url, :image_width, :image_height, :manual_enter]]
    )
  end

  def set_duration(param)
    @hours = param[:hours]
    @minutes = param[:minutes]
    @seconds = param[:seconds]
    if @hours.present? && @minutes.present? && @seconds.present?
      @hours.to_i.hour.to_i + @minutes.to_i.minute.to_i + @seconds.to_i
    else
      0
    end
  end

  def get_time(duration)
    if duration.present?
      @seconds = duration % 60
      @minutes = (duration / 60) % 60
      @hours = duration / (60 * 60)
    else
      @hours = 0
      @minutes = 0
      @seconds = 0
    end
  end

  def set_fields_on_fail(hash)
    @title                        = hash['title']
    @meta_desc                    = hash['description']
    @link_creator                 = hash['video_creator']
    @link_channel_id              = hash['channel_id']
    @link_image                   = hash['thumbnail_url']
    @meta_keywords                = hash['url_keywords']
    @meta_tagline                 = hash["editor_tagline"]
    @meta_type                    = hash["story_type"]
    @meta_views                   = hash["views"]
    @meta_likes                   = hash["likes"]
    @meta_dislikes                = hash["dislikes"]
    @meta_subscribers             = hash["subscribers"]
    @unlisted                     = hash["unlisted"]
    @hashtags                     = hash["hashtags"]
    @video_hashtags               = hash["video_hashtags"]
    @year                         = hash["story_year"]
    @month                        = hash["story_month"]
    @day                          = hash["story_date"]
    @selected_location_ids        = process_chosen_params(hash['location_ids'])
    @selected_place_category_ids  = process_chosen_params(hash['place_category_ids'])
    @selected_story_category_ids  = process_chosen_params(hash['story_category_ids'])
  end

  def review_update_params
    params.require(:video_story).permit(:desc_length)
  end

end
