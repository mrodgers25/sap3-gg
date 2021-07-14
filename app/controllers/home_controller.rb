class HomeController < ApplicationController
  layout "application"

  before_action :set_limit, only: :index
  before_action :filter_out_file_types_from_url, only: :index

  def index
    # database dropdown data
    @story_regions    = StoryRegion.order("ascii(name)")
    @place_groupings  = PlaceGrouping.order(:name)
    @story_categories = StoryCategory.order(:name)

    @published_items = PublishedItem.joins("
      INNER JOIN stories ON (publishable_type = 'Story' AND stories.id = publishable_id)
      LEFT JOIN stories_users ON stories_users.story_id = stories.id
      LEFT JOIN stories_story_regions ON stories_story_regions.story_id = stories.id
      LEFT JOIN story_regions ON story_regions.id = stories_story_regions.story_region_id
      LEFT JOIN place_groupings_stories ON place_groupings_stories.story_id = stories.id
      LEFT JOIN place_groupings ON place_groupings.id = place_groupings_stories.place_grouping_id
      LEFT JOIN story_story_categories ON story_story_categories.story_id = stories.id
      LEFT JOIN story_categories ON story_categories.id = story_story_categories.story_category_id
    ").select('published_items.*, stories.*, stories_users.created_at AS save_date')

    if params[:story_region_id].present? || params[:place_grouping_id].present? || params[:story_category_id].present?
      @published_items = @published_items.where(story_regions: { id: params[:story_region_id] }) if params[:story_region_id].present?
      @published_items = @published_items.where(place_groupings: { id: params[:place_grouping_id] }) if params[:place_grouping_id].present?
      @published_items = @published_items.where(story_categories: { id: params[:story_category_id] }) if params[:story_category_id].present?
      @published_items = @published_items.limit(AdminSetting.filtered_display_limit)
      @published_items = @published_items.order(created_at: :desc)
    else
      @published_items = @published_items.where(state: 'newsfeed').limit(AdminSetting.newsfeed_display_limit)
      @published_items = @published_items.order(pinned: :desc, posted_at: :desc)
    end

    @published_items = @published_items.distinct
  end

  def about_us
  end

  def contact_us
  end

  private

  def set_limit
    # story_limit = Code.find_by(code_key: "LANDING_PAGE_STORY_COUNT").code_value
    @story_limit = current_user&.has_basic_access? ? 75 : 36
  end
end
