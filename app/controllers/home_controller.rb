# frozen_string_literal: true

class HomeController < ApplicationController
  layout 'application'

  before_action :set_limit, only: :index
  before_action :filter_out_file_types_from_url, only: :index

  def index
    # database dropdown data
    @locations        = Location.order('ascii(name)')
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)

    @published_items = PublishedItem.joins("
      INNER JOIN stories ON (publishable_type = 'Story' AND stories.id = publishable_id)
      LEFT JOIN stories_users ON stories_users.story_id = stories.id
      LEFT JOIN story_locations ON story_locations.story_id = stories.id
      LEFT JOIN locations ON locations.id = story_locations.location_id
      LEFT JOIN story_place_categories ON story_place_categories.story_id = stories.id
      LEFT JOIN place_categories ON place_categories.id = story_place_categories.place_category_id
      LEFT JOIN story_story_categories ON story_story_categories.story_id = stories.id
      LEFT JOIN story_categories ON story_categories.id = story_story_categories.story_category_id
    ").select('published_items.*, stories.*, stories_users.created_at AS save_date')

    if params[:location_id].present? || params[:place_category_id].present? || params[:story_category_id].present?
      @published_items = @published_items.where(locations: { id: params[:location_id] }) if params[:location_id].present?
      @published_items = @published_items.where(place_categories: { id: params[:place_category_id] }) if params[:place_category_id].present?
      @published_items = @published_items.where(story_categories: { id: params[:story_category_id] }) if params[:story_category_id].present?
      @published_items = @published_items.limit(AdminSetting.filtered_display_limit)
      @published_items = @published_items.order(created_at: :desc)
    else
      @published_items = @published_items.where(state: 'newsfeed').limit(AdminSetting.newsfeed_display_limit)
      @published_items = @published_items.order(pinned: :desc, posted_at: :desc)
    end

    @published_items = @published_items.distinct
  end

  def about_us; end

  def contact_us; end

  private

  def set_limit
    # story_limit = Code.find_by(code_key: "LANDING_PAGE_STORY_COUNT").code_value
    @story_limit = current_user&.has_basic_access? ? 75 : 36
  end
end
