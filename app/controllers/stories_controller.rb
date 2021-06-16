class StoriesController < ApplicationController
  include Pagy::Backend

  before_action :set_story_by_permalink, only: [:show]
  before_action :set_story, only: [:show, :save, :forget]
  before_action :check_for_current_user, only: :my_stories

  def show
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
    @locations        = Location.order("ascii(name)")
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)

    @published_items = PublishedItem.joins("
      INNER JOIN stories ON (stories.id = publishable_id)
      LEFT JOIN stories_users ON stories_users.story_id = stories.id
      LEFT JOIN story_locations ON story_locations.story_id = stories.id
      LEFT JOIN locations ON locations.id = story_locations.location_id
      LEFT JOIN story_place_categories ON story_place_categories.story_id = stories.id
      LEFT JOIN place_categories ON place_categories.id = story_place_categories.place_category_id
      LEFT JOIN story_story_categories ON story_story_categories.story_id = stories.id
      LEFT JOIN story_categories ON story_categories.id = story_story_categories.story_category_id
    ").select('published_items.*, stories.*, stories_users.created_at AS save_date')
    @published_items = @published_items.where(stories_users: { user_id: current_user.id })
    @published_items = @published_items.where(locations: { id: params[:location_id] }) if params[:location_id].present?
    @published_items = @published_items.where(place_categories: { id: params[:place_category_id] }) if params[:place_category_id].present?
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
      @story = Story.find_by(permalink: params[:id])

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
