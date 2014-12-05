class VisitorsController < ApplicationController
  require 'google-webfonts'

  def index

    # track user activity on landing page
    track_action
    ahoy.track "Page", title: "Landing"

    story_limit = Code.find_by(code_key: "LANDING_PAGE_STORY_COUNT").code_value unless \
      Code.find_by(code_key: "LANDING_PAGE_STORY_COUNT").nil?
    story_limit ||= 36
    @stories = Story.order("id DESC").where("sap_publish_date is not null").includes(:urls => [:images]).limit(story_limit)
    @stories_filtered = Story.order("story_year DESC","story_month DESC","story_date DESC").where("sap_publish_date is not null").includes(:urls => [:images]).limit(story_limit)

    flash.now.alert = "No Stories found" if @stories.empty?

    # database dropdown data
    @location_codes = Code.order("ascii(code_value)").where("code_type = 'LOCATION_CODE'")
    @story_place_types = Code.order("code_value").where("code_type = 'PLACE_CATEGORY'")
    @story_categories_loggedin = Code.order("ascii(code_value)").where("code_type = 'STORY_CATEGORY'")
    @story_categories_notloggedin = Code.order("ascii(code_value)").where("code_type = 'STORY_CATEGORY' and code_key != 'EP'")
    @stories = @stories_filtered.user_location_code(params[:user_location_code]) if params[:user_location_code].present?
    @stories = @stories_filtered.user_place_category(params[:user_place_category]) if params[:user_place_category].present?
    @stories = @stories_filtered.user_story_category(params[:user_story_category]) if params[:user_story_category].present?

  end

  def refresh_timer

  end

protected

  def track_action
    ahoy.track "Processed #{controller_name}##{action_name}", request.filtered_parameters
  end

end
