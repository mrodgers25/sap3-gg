class MyStoriesController < ApplicationController
  layout "application_v2"
  before_action :authenticate_user!

  def index
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
  end
end
