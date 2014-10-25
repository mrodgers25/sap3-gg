class VisitorsController < ApplicationController

  def index

    story_limit = Code.find_by(code_key: "LANDING_PAGE_STORY_COUNT").code_value.present? ? \
      Code.find_by(code_key: "LANDING_PAGE_STORY_COUNT").code_value : 36
    @stories = Story.order("id DESC").limit(36).includes(:urls => [:images]).limit(story_limit)

    @stories = @stories.user_location_code(params[:user_location_code]) if params[:user_location_code].present?
    @stories = @stories.user_place_category(params[:user_place_category]) if params[:user_place_category].present?
    @stories = @stories.user_story_category(params[:user_story_category]) if params[:user_story_category].present?

    flash.now.alert = "No Stories found" if @stories.empty?

  end


private

end

