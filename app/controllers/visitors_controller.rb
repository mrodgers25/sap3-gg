class VisitorsController < ApplicationController
  require 'google-webfonts'

  def index

    # track user activity on landing page
    track_action

    # database dropdown data
    @location_codes = Location.order(:name)
    @story_place_types = PlaceCategory.order(:name)
    @story_categories_loggedin = StoryCategory.order(:name)
    @story_categories_notloggedin = StoryCategory.where.not(code: 'EP').order(:name)

    unless Code.find_by(code_key: "LANDING_PAGE_STORY_COUNT").nil?
      story_limit = Code.find_by(code_key: "LANDING_PAGE_STORY_COUNT").code_value
    end
    story_limit ||= 36
    unless Code.find_by(code_key: "LANDING_PAGE_FILTERED_COUNT").nil?
      story_limit_filtered = Code.find_by(code_key: "LANDING_PAGE_FILTERED_COUNT").code_value
    end
    story_limit_filtered ||= 36

    @stories = Story.order("id DESC").where("sap_publish_date is not null").includes(:urls => [:images]).limit(story_limit)
    @stories_filtered = Story.where("sap_publish_date is not null").includes(:urls => [:images]).limit(story_limit)

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

  def refresh_timer

  end

  def save_story
    respond_to do |format|
      format.json do
        if user_signed_in?
          user_saved_story = Usersavedstory.new
          user_saved_story.user_id = current_user.id.to_i
          user_saved_story.story_id = params[:id].to_i
          if user_saved_story.save
            render json: {success: true}
          else
            render json: {success: false}
          end
        end
      end
    end
  end

  def forget_story
    respond_to do |format|
      format.json do
        if user_signed_in?
          user_saved_story = Usersavedstory.where(story_id: params[:id], user_id: current_user.id).first
          if user_saved_story && user_saved_story.destroy
            render json: {success: true}
          else
            render json: {success: false}
          end
        end
      end
    end
  end

  protected

  def track_action
    ahoy.track "Processed #{controller_name}##{action_name}", request.filtered_parameters
  end

end
