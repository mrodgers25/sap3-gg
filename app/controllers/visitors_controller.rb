class VisitorsController < ApplicationController

  def index

    # database dropdown object
    @location_codes = Code.order("ascii(code_value)").where("code_type = 'LOCATION_CODE'")

    story_limit = Code.find_by(code_key: "LANDING_PAGE_STORY_COUNT").code_value unless \
      Code.find_by(code_key: "LANDING_PAGE_STORY_COUNT").nil?
    story_limit ||= 36
    @stories = Story.order("id DESC").where("sap_publish_date is not null").includes(:urls => [:images]).limit(story_limit)

    @stories = @stories.user_location_code(params[:user_location_code]) if params[:user_location_code].present?
    @stories = @stories.user_place_category(params[:user_place_category]) if params[:user_place_category].present?
    @stories = @stories.user_story_category(params[:user_story_category]) if params[:user_story_category].present?

    flash.now.alert = "No Stories found" if @stories.empty?

    # respond_to do |format|
    #   format.js
    # end

  end

  def refresh_timer

  end

private

end

