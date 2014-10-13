class VisitorsController < ApplicationController

  def index
    @stories = Story.where(nil)  # creates an anonymous scope
    # @stories = Story.story_place_code(params[:story_place_code]) if params[:story_place_code].present?
    # @stories = Story.story_place_code(params[:story_place_code]).order("id DESC").limit(36).includes(:urls).limit(36) if params[:story_place_code].present?
    # @stories_pre = Story.order("id DESC").limit(36).includes(:urls).limit(36)
    if params[:user_place_category].present?
      @stories = Story.order("id DESC").limit(36).includes(:urls).user_place_category(params[:user_place_category])
    else
      @stories = Story.order("id DESC").limit(36).includes(:urls).limit(36)
    end
    unless @stories.first.nil?
      @urls = @stories.first.urls.includes(:images)
    else
      flash.now.alert = "No Stories found"
    end
    @images = @urls.first.images unless @urls.nil?
    # binding.pry
  end

private

end

