class VisitorsController < ApplicationController

  def index
    @stories = Story.order("id DESC").first(5)
    @urls = @stories.first.urls
    @images = @urls.first.images
  end

end
