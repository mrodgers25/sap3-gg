class StoriesController < ApplicationController
  before_action :set_story, only: [:save_story, :forget_story]

  def show
    @story = Story.find_by(permalink: params[:id])

    render layout: "application_no_nav"
  end

  def save_story
    @story.users << current_user

    if @story.save
      render :json => { success: true, message: 'Story saved' }
    else
      render :json => { success: false, message: 'Error occured' }
    end
  end

  def forget_story
    @story.users.delete(current_user)

    if @story.save
      render :json => { success: true, message: 'Forgot story' }
    else
      render :json => { success: false, message: 'Error occured' }
    end
  end

  def my_stories
    # database dropdown data
    @locations        = Location.order("ascii(name)")
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)

    @stories = Story.includes(:stories_users).select("stories.*", "stories_users.created_at AS save_date")
    @stories = @stories.where(stories_users: { user_id: current_user.id })
    @stories = @stories.joins(:locations).where("locations.id = #{params[:location_id]}") if params[:location_id].present?
    @stories = @stories.joins(:place_categories).where("place_categories.id = #{params[:place_category_id]}") if params[:place_category_id].present?
    @stories = @stories.joins(:story_categories).where("story_categories.id = #{params[:story_category_id]}") if params[:story_category_id].present?
    @stories = @stories.order('stories_users.created_at ASC')

    render layout: "application"
  end

  private

  def set_story
    begin
      @story = Story.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: 'Story not found'
    end
  end
end
