class VisitorsController < ApplicationController

  def index
    @stories = Story.order("id DESC").limit(36).includes(:urls).limit(36)
    @urls = @stories.first.urls.includes(:images)
    @images = @urls.first.images

end

end
