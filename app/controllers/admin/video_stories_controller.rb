require 'video_scraper'

class Admin::VideoStoriesController < Admin::BaseAdminController
  before_action :get_locations_and_categories, only: [:index, :new, :scrape, :edit]
  before_action :set_video_story, only: [:show, :edit, :update, :destroy, :review, :review_update, :update_state]

  def scrape

    @video_story = VideoStory.new

    @screen_scraper = VideoScraper.new

    @data_entry_begin_time = params[:data_entry_begin_time]
    @source_url_pre        = params[:source_url_pre]

    get_domain_info(@source_url_pre)

    if @screen_scraper.scrape!(@full_web_url)
      url = @video_story.urls.build
      url.images.build
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
      @video_story.story_type = 'Youtube'
      #This script is used to update the permalink field in all stories
      url_title = @video_story.urls.first.url_title.parameterize
      rand_hex = SecureRandom.hex(2)
      permalink = "#{rand_hex}/#{url_title}"
      @video_story.update_attribute(:permalink, "#{permalink}")

      update_locations_and_categories(@video_story, video_story_params)
      redirect_to review_admin_video_story_path(@video_story), notice: 'Story was moved to draft mode.'
    else
      @source_url_pre = params["story"]["urls_attributes"]["0"]["url_full"]
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
    @outside_usa      = @video_story.outside_usa
    @year             = @video_story.story_year
    @month            = @video_story.story_month
    @day              = @video_story.story_date
    @link_creator     = @video_story.video_creator
    @link_channel_id  = @video_story.video_channel_id
    @meta_views       = @video_story.video_views
    @meta_likes       = @video_story.video_likes
    @meta_dislikes    = @video_story.video_dislikes
    @meta_subscribers = @video_story.video_subscribers
    @unlisted         = @video_story.video_unlisted
    @hashtags         = @video_story.hashtags
    @video_hashtags   = @video_story.video_hashtags

    # url fields
    @url1           = @video_story.urls.first
    @full_web_url   = @url1.url_full
    @base_domain    = @url1.url_domain
    @title          = @url1.url_title
    @meta_desc      = @url1.url_desc
    @meta_keywords  = @url1.url_keywords

    # image fields
   @image1    = @url1.images.first
   @page_imgs = [{
     'src_url' => @image1.src_url,
     'alt_text' => @image1.alt_text,
     'image_width' => @image1.image_width,
     'image_height' => @image1.image_height
   }]
    @link_image       = @image1.src_url

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
      redirect_to admin_stories_path, notice: 'Video Story was successfully updated.'
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
      :editor_tagline, :hashtags, :video_creator, :video_channel_id,
      :video_views, :video_subscribers, :video_likes, :video_dislikes, :video_unlisted,
      :video_duration, :video_hashtags, :outside_usa, :state,
      :story_year, :story_month, :story_date,
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
    @title = hash['urls_attributes']['0']['url_title']
    @meta_desc = hash['urls_attributes']['0']['url_desc']
    @meta_keywords = hash['urls_attributes']['0']['url_keywords']
    @meta_tagline = hash["editor_tagline"]
    @link_creator                 = hash['video_creator']
    @link_channel_id              = hash['video_channel_id']
    @meta_type                    = hash["story_type"]
    @meta_views                   = hash["video_views"]
    @meta_likes                   = hash["video_likes"]
    @meta_dislikes                = hash["video_dislikes"]
    @meta_subscribers             = hash["video_subscribers"]
    @unlisted                     = hash["video_unlisted"]
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
