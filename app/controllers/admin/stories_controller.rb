class Admin::StoriesController < Admin::BaseAdminController
  before_action :set_story, only: [:show, :destroy, :review, :review_update, :update_state]
  before_action :check_for_admin, only: :destroy

  def index
     # database dropdown data
    @locations        = Location.order("ascii(name)")
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)

    @stories = Story.joins(:urls).select(
      "stories.*",
      "
        CASE
          WHEN story_year > 0 AND story_month > 0 AND story_date > 0
          THEN TO_DATE(CONCAT(story_year::TEXT, '-', story_month::TEXT, '-', story_date::TEXT), 'YYYY-MM-DD')
          WHEN story_year > 0 AND story_month > 0
          THEN TO_DATE(CONCAT(story_year::TEXT, '-', story_month::TEXT), 'YYYY-MM')
          ELSE null
        END AS story_date_combined
      "
    )
    @stories = @stories.where("LOWER(type) ~ ?", params[:type].downcase) if params[:type].present?
    @stories = @stories.where("LOWER(urls.url_title) ~ ?", params[:url_title].downcase) if params[:url_title].present?
    @stories = @stories.where("LOWER(urls.url_desc) ~ ?", params[:url_desc].downcase) if params[:url_desc].present?
    @stories = @stories.where(state: params[:state]) if params[:state].present?
    @stories = @stories.joins(:locations).where(locations: { id: params[:location_id] }) if params[:location_id].present?
    @stories = @stories.joins(:place_categories).where(place_categories: { id: params[:place_category_id] }) if params[:place_category_id].present?
    @stories = @stories.joins(:story_categories).where(story_categories: { id: params[:story_category_id] }) if params[:story_category_id].present?
    @stories = @stories.order(story_date_combined: :desc)

    @pagy, @stories = pagy(@stories)
  end

  def show
    render layout: "application_no_nav"
  end

  def review
  end

  def review_update
    if @story.update(review_update_params)
      redirect_to review_admin_story_path(@story), notice: 'Story was successfully updated.'
    else
      redirect_to review_admin_story_path(@story), notice: 'Story failed to be updated.'
    end
  end

  def approve
    if @story.approve!
      redirect_to admin_stories_path, notice: "Story has been approved!"
    else
      redirect_to admin_stories_path, alert: "Story has NOT been approved."
    end
  end

  def update_state
    debugger
    begin
      case params[:state]
      when 'needs_review'
        @story.request_review!
      when 'do_not_publish'
        @story.hide!
      when 'completed'
        @story.complete!
      when 'removed_from_public'
        @story.remove!
      when 'no_status'
        @story.reset!
      end

      redirect_to review_admin_story_path(@story), notice: "Story saved as #{params[:state].titleize}"
    rescue
      redirect_to review_admin_story_path(@story), alert: 'Story failed to update'
    end
  end

  private

  def set_story
    begin
      @story = Story.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_stories_path, alert: "Story not found"
    end
  end

  def get_camalized_story_type
    if @story.media_story?
      type = 'media_story'.to_sym
    elsif @story.video_story?
      type = 'video_story'.to_sym
    end
  end


  def review_update_params
    params.require(get_camalized_story_type).permit(:desc_length)
  end

  def update_state_params
    params.require(get_camalized_story_type).permit(:state)
  end
end
