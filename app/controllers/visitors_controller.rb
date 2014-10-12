class VisitorsController < ApplicationController

  def index
    @stories = Story.where(nil)  # creates an anonymous scope
    # @stories = Story.story_place_code(params[:story_place_code]) if params[:story_place_code].present?
    # @stories = Story.story_place_code(params[:story_place_code]).order("id DESC").limit(36).includes(:urls).limit(36) if params[:story_place_code].present?
    # @stories_pre = Story.order("id DESC").limit(36).includes(:urls).limit(36)
    if params[:story_place_code].present?
      @stories = Story.order("id DESC").limit(36).includes(:urls).story_place_code(params[:story_place_code])
    else
      @stories = Story.order("id DESC").limit(36).includes(:urls).limit(36)
    end
    @urls = @stories.first.urls.includes(:images)
    @images = @urls.first.images

  end

end