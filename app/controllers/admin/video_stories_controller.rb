require 'video_scraper'

class Admin::VideoStoriesController < Admin::BaseAdminController
  before_action :set_video_story, only: %i[edit update]

  def scrape
    @video_story = VideoStory.new
    @screen_scraper = VideoScraper.new
    @data_entry_begin_time = params[:data_entry_begin_time]
    get_locations_and_categories

    if @screen_scraper.scrape!(params[:source_url_pre])
      url = @video_story.urls.build
      url.url_full = params[:source_url_pre]
      set_scrape_fields
    else
      flash.now.alert = 'Something went wrong with the scraper.'
      redirect_to admin_initialize_scraper_index_path
    end
  end

  def create
    @video_story = VideoStory.new(video_story_params)
    @video_story.video_duration = set_duration(params[:video_story])
    if @video_story.save
      # Update the permalink field
      @video_story.create_permalink
      update_locations_and_categories(@video_story, video_story_params)
      redirect_to redirect_to_next_path(images_admin_story_path(@video_story)), notice: 'Story was saved.'
    else
      get_time(@video_story.video_duration)
      get_locations_and_categories
      render :scrape
    end
  end

  def edit
    # locations and categories
    get_locations_and_categories
    get_time(@video_story.video_duration)
  end

  def update
    @video_story.video_duration = set_duration(params[:video_story])
    if @video_story.update(video_story_params)
      update_locations_and_categories(@video_story, video_story_params)

      redirect_to redirect_to_next_path(images_admin_story_path(@video_story)),
                  notice: 'Video Story was successfully updated.'
    else
      redirect_to edit_admin_video_story_path(@video_story), notice: 'Story failed to be updated.'
    end
  end

  private

  def set_video_story
    @video_story = VideoStory.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_stories_path, alert: 'Video Story not found'
  end

  def set_scrape_fields
    @video_story.video_creator    = @screen_scraper.link_creator
    @video_story.video_channel_id = @screen_scraper.link_channel_id
    @video_story.story_year       = @screen_scraper.year
    @video_story.story_month      = @screen_scraper.month
    @video_story.story_date = @screen_scraper.day

    url = @video_story.urls.last
    url.url_title                 = @screen_scraper.title
    url.url_desc                  = @screen_scraper.meta_desc
    url.url_keywords              = @screen_scraper.meta_keywords
  end

  def update_locations_and_categories(story, my_params)
    new_locations = Location.find(process_chosen_params(my_params[:location_ids]))
    story.locations = new_locations

    new_story_categories = StoryCategory.find(process_chosen_params(my_params[:story_category_ids]))
    story.story_categories = new_story_categories

    new_place_categories = PlaceCategory.find(process_chosen_params(my_params[:place_category_ids]))
    story.place_categories = new_place_categories
  end

  def process_chosen_params(my_params)
    my_params.reject { |p| p.empty? }.map { |p| p.to_i } if my_params.present?
  end

  def get_locations_and_categories
    @locations        = Location.order('ascii(name)')
    @story_categories = StoryCategory.order(:name)
    @place_categories = PlaceCategory.order(:name)
  end

  def video_story_params
    params.require(:video_story).permit(
      :editor_tagline, :hashtags, :video_creator, :video_channel_id,
      :video_views, :video_subscribers, :video_likes, :video_dislikes, :video_unlisted,
      :video_duration, :video_hashtags, :outside_usa, :state,
      :story_year, :story_month, :story_date,
      :data_entry_begin_time, :data_entry_user, :desc_length,
      location_ids: [],
      place_category_ids: [],
      story_category_ids: [],
      urls_attributes: %i[
        id url_type url_full url_title url_desc url_keywords url_domain primary story_id
        url_title_track url_desc_track url_keywords_track
        raw_url_title_scrape raw_url_desc_scrape raw_url_keywords_scrape
      ]
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
