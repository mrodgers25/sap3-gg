class VisitorsController < ApplicationController

  def index
    # @stories = Story.where(nil)  # creates an anonymous scope

    @stories = Story.order("id DESC").limit(36).includes(:urls => [:images]).limit(36)

    @stories = @stories.user_location_code(params[:user_location_code]) if params[:user_location_code].present?
    @stories = @stories.user_place_category(params[:user_place_category]) if params[:user_place_category].present?
    @stories = @stories.user_story_category(params[:user_story_category]) if params[:user_story_category].present?

    flash.now.alert = "No Stories found" if @stories.empty?

    # if params[:user_place_category].present?
    #   @stories = Story.order("id DESC").limit(36).includes(:urls => [:images]).user_place_category(params[:user_place_category])
    # else
    #   @stories = Story.order("id DESC").limit(36).includes(:urls => [:images]).limit(36)
    # end
    # unless @stories.first.nil?
    #   @urls = @stories.first.urls.includes(:images)
    # else
    #   flash.now.alert = "No Stories found"
    # end
    # @images = @urls.first.images unless @urls.nil?
    # binding.pry
  end


private

end

