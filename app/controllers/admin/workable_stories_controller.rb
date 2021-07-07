class Admin::WorkableStoriesController < Admin::BaseAdminController
  before_action :set_story, only: [:activities, :assign, :unassign]

  def index
     @stories = Story.left_outer_joins(:urls).select(
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
    @stories = @stories.where.not(state: ['removed_from_public', 'do_not_publish', 'completed'])
    @stories = @stories.where("type ~ ?", params[:type]) if params[:type].present?
    @stories = @stories.where("LOWER(urls.url_title) ~ ?", params[:url_title].downcase) if params[:url_title].present?
    @stories = @stories.where(state: params[:state]) if params[:state].present?
    @stories = @stories.where.not(assigned_to: current_user.id) unless params[:show_assigned_stories].present?
    @stories = @stories.where.not(assigned_to: nil) if params[:show_assigned_stories].present?
    @stories = @stories.order(story_date_combined: :desc, id: :desc)

    @pagy, @stories = pagy(@stories)
  end

  def activities
    @activities = @story.story_activities.order(id: :desc)
  end

  def assign
    @story.update!(assign_params)
    redirect_to admin_workable_stories_path, notice: "Story unassigned to User: #{@story.assignee}"
  rescue => e
    redirect_to admin_workable_stories_path, alert: e
  end

  def unassign
    @story.update!(assigned_to: nil)
    redirect_to admin_workable_stories_path, notice: "Story unassigned from User"
  rescue => e
    redirect_to admin_workable_stories_path, alert: e
  end

  private


  def set_story
    begin
      @story = Story.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_workable_stories_path, alert: "Story not found"
    end
  end
end
