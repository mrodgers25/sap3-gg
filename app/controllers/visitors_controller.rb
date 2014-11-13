class VisitorsController < ApplicationController

  def index

    story_limit = Code.find_by(code_key: "LANDING_PAGE_STORY_COUNT").code_value unless \
      Code.find_by(code_key: "LANDING_PAGE_STORY_COUNT").nil?
    story_limit ||= 36
    @stories = Story.order("id DESC").where("sap_publish_date is not null").includes(:urls => [:images]).limit(story_limit)

    flash.now.alert = "No Stories found" if @stories.empty?

    # database dropdown data
    @location_codes = Code.order("ascii(code_value)").where("code_type = 'LOCATION_CODE'")
    @story_place_types = Code.order("code_value").where("code_type = 'PLACE_CATEGORY'")
    @story_categories_loggedin = Code.order("ascii(code_value)").where("code_type = 'STORY_CATEGORY'")
    @story_categories_notloggedin = Code.order("ascii(code_value)").where("code_type = 'STORY_CATEGORY' and code_key != 'EP'")
    @stories = @stories.user_location_code(params[:user_location_code]) if params[:user_location_code].present?
    @stories = @stories.user_place_category(params[:user_place_category]) if params[:user_place_category].present?
    @stories = @stories.user_story_category(params[:user_story_category]) if params[:user_story_category].present?

    # scheduler data - not used because timer display doesn't work for some reason when calling these from here instead on in view
    # @code_for_next_pub = Code.where("code_key = 'NEXT_STORY_PUB_DATETIME'")
    # @next_story_pub_datetime = Code.where("code_key = 'NEXT_STORY_PUB_DATETIME'").pluck("updated_at","code_value").first

    # respond_to do |format|
    #   format.js
    # end

  end

  def refresh_timer

  end

private

end

