class HomeController < ApplicationController
  layout "application-v2"

  def index
    # database dropdown data
    @locations        = Location.order("ascii(name)")
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)

    unless Code.find_by(code_key: "LANDING_PAGE_STORY_COUNT").nil?
      story_limit = Code.find_by(code_key: "LANDING_PAGE_STORY_COUNT").code_value
    end

    if user_signed_in? && current_user.admin?
      story_limit = 75
    else
      story_limit = 36
    end

    # story_limit ||= 36
    unless Code.find_by(code_key: "LANDING_PAGE_FILTERED_COUNT").nil?
      story_limit_filtered = Code.find_by(code_key: "LANDING_PAGE_FILTERED_COUNT").code_value
    end

    if user_signed_in? && current_user.admin?
      story_limit_filtered = 75
    else
      story_limit_filtered = 36
    end

    @stories = Story.order("sap_publish_date DESC").where("sap_publish_date is not null").includes(:urls => [:images]).includes(:urls => [:mediaowner]).limit(story_limit)
    # @stories = Story.order("id DESC").where("sap_publish_date is not null").includes(:urls => [:images]).includes(:urls => [:mediaowner]).limit(story_limit)
    @stories_filtered = Story.where("sap_publish_date is not null").includes(:urls => [:images]).includes(:urls => [:mediaowner]).limit(story_limit)

    if params[:location_id].present? || params[:place_category_id].present? || params[:story_category_id].present?
      @stories = @stories_filtered.order("story_year DESC","story_month DESC","story_date DESC").limit(story_limit_filtered)
    end
    if params[:location_id].present?
      @stories = @stories.joins(:locations).where("locations.id = #{params[:location_id]}")
    end
    if params[:place_category_id].present?
      @stories = @stories.joins(:place_categories).where("place_categories.id = #{params[:place_category_id]}")
    end
    if params[:story_category_id].present?
      @stories = @stories.joins(:story_categories).where("story_categories.id = #{params[:story_category_id]}")
    end

    flash.now.alert = "No Stories found" if @stories.empty?
  end
end
