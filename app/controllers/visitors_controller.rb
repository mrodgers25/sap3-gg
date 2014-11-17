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

    # menu display
    if user_signed_in?
      # signedin_as = ""
      fname = ""
      lname = ""
      lname = current_user.last_name unless current_user.last_name.nil?
      fname = current_user.first_name unless current_user.first_name.nil?
      signedin_as = first_name + " " + last_name
    #   signedin_as = current_user.first_name + " " + current_user.last_name
    #   @signedin_as = signedin_as == " " ? current_user.email : signedin_as
    end
  end

  def refresh_timer

  end

private

end

