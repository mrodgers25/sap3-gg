require 'video_scraper'

class Admin::VideoStoriesController < Admin::BaseAdminController
  before_action :set_video_story, only: [:edit, :update]

  def scrape
    @video_story = VideoStory.new
    @screen_scraper = VideoScraper.new
    @data_entry_begin_time = params[:data_entry_begin_time]
    get_locations_and_categories

    if @screen_scraper.scrape!(params[:source_url_pre])
      url = @video_story.urls.build
      url.url_full = params[:source_url_pre]
      url.images.build
      set_scrape_fields
    else
      flash.now.alert = "Something went wrong with the scraper."
      redirect_to admin_initialize_scraper_index_path
    end
  end

  def create
    @video_story = VideoStory.new(video_story_params)
    @video_story.video_duration = set_duration(params[:video_story])
    if @video_story.save
      #Update the permalink field
      @video_story.create_permalink
      update_locations_and_categories(@video_story, video_story_params)
      redirect_to review_admin_story_path(@video_story), notice: 'Story was saved.'
    else
      set_fields_on_fail(video_story_params)
      get_locations_and_categories
      render :scrape
    end
  end

  def edit
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
      update_locations_and_categories(@video_story, video_story_params)

      redirect_to admin_stories_path, notice: 'Video Story was successfully updated.'
    else
      redirect_to edit_admin_video_story_path(@video_story), notice: 'Story failed to be updated.'
    end
  end

  private

  def set_video_story
    begin
      @video_story = VideoStory.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_stories_path, alert: "Video Story not found"
    end
  end


  def set_scrape_fields
    @video_story.video_creator    = @screen_scraper.link_creator
    @video_story.video_channel_id = @screen_scraper.link_channel_id
    @video_story.story_year             = @screen_scraper.year
    @video_story.story_month            = @screen_scraper.month
    @video_story.story_day              = @screen_scraper.day

    url = @video_story.urls.last
    url.url_title                 = @screen_scraper.title
    url.url_desc                  = @screen_scraper.meta_desc
    url.images.first.src_url      = @screen_scraper.link_image
    url.url_keywords              = @screen_scraper.meta_keywords
  end

  def set_fields_on_fail(hash)
    @selected_location_ids        = process_chosen_params(hash['location_ids'])
    @selected_place_category_ids  = process_chosen_params(hash['place_category_ids'])
    @selected_story_category_ids  = process_chosen_params(hash['story_category_ids'])
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
end
