class StoriesController < ApplicationController
  include Pagy::Backend

  before_action :set_story_by_permalink, only: :view
  before_action :set_story, only: [:save, :forget]
  before_action :check_for_current_user, only: :my_stories

  def view
    render layout: "application_no_nav"
  end

  def save
    @story.users << current_user

    if @story.savable? && @story.save
      render json: { success: true, message: 'Story saved' }
    else
      render json: { success: false, message: 'Error occured' }
    end
  end

  def forget
    @story.users.delete(current_user)

    respond_to do |format|
      if @story.save
        format.json { render json: { success: true, message: 'Forgot story' }}
        format.html { redirect_to my_stories_path, notice: 'Forgot story' }
      else
        format.json { render json: { success: false, message: 'Error occured' }}
        format.html { redirect_to my_stories_path, notice: 'Error occured' }
      end
    end
  end

  def my_stories
    # database dropdown data
    @story_regions    = StoryRegion.order("ascii(name)")
    @place_groupings  = PlaceGrouping.order(:name)
    @story_categories = StoryCategory.order(:name)

    @published_items = PublishedItem.joins("
      INNER JOIN stories ON (stories.id = publishable_id)
      LEFT JOIN stories_users ON stories_users.story_id = stories.id
      LEFT JOIN stories_story_regions ON stories_story_regions.story_id = stories.id
      LEFT JOIN story_regions ON story_regions.id = stories_story_regions.story_region_id
      LEFT JOIN place_groupings_stories ON place_groupings_stories.story_id = stories.id
      LEFT JOIN place_groupings ON place_groupings.id = place_groupings_stories.place_grouping_id
      LEFT JOIN story_story_categories ON story_story_categories.story_id = stories.id
      LEFT JOIN story_categories ON story_categories.id = story_story_categories.story_category_id
    ").select('published_items.*, stories.*, stories_users.created_at AS save_date')
    @published_items = @published_items.where(stories_users: { user_id: current_user.id })
    @published_items = @published_items.where(story_regions: { id: params[:story_region_id] }) if params[:story_region_id].present?
    @published_items = @published_items.where(place_groupings: { id: params[:place_grouping_id] }) if params[:place_grouping_id].present?
    @published_items = @published_items.where(story_categories: { id: params[:story_category_id] }) if params[:story_category_id].present?
    @published_items = @published_items.order('stories_users.created_at ASC').distinct

    @pagy, @published_items = pagy(@published_items)

    render layout: "application"
  end

  private

  def set_story
    begin
      @story = Story.find(params[:id])

      unless current_user&.has_basic_access?
        raise ActiveRecord::RecordNotFound if @story.should_not_be_displayed?
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: 'Story not found'
    end
  end

  def set_story_by_permalink
    begin
      @story = Story.find_by(permalink: params[:permalink])

      unless current_user&.has_basic_access?
        raise ActiveRecord::RecordNotFound if @story.should_not_be_displayed?
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: 'Story not found'
    end
  end

  def check_for_current_user
    redirect_to root_path, alert: 'User not found' unless current_user
  end
end
