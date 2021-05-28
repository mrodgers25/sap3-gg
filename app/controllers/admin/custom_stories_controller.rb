class Admin::CustomStoriesController < Admin::BaseAdminController
  before_action :set_story, only: [:edit, :update]
  before_action :get_locations_and_categories, only: [:new, :edit]

  def new
    @story = CustomStory.new
  end

  def create
    @story = CustomStory.new(story_params)

    if @story.save
      # @story.internal_image.attach(story_params[:internal_image])
      redirect_to admin_stories_path, notice: 'Story was successfully created.'
    else
      render :new, Alert: 'Story was not created.'
    end
  end

  def edit
  end

  def update
    if @story.update(story_params)
      redirect_to admin_stories_path, notice: 'Story was successfully updated.'
    else
      redirect_to edit_admin_custom_story_path(@story), alert: 'Story failed to be updated.'
    end
  end

  private

  def set_story
    begin
      @story = CustomStory.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_stories_path, alert: "Custom Story not found"
    end
  end

  def get_locations_and_categories
    @locations        = Location.order("ascii(name)")
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)
  end

  def story_params
    params.require(:custom_story).permit(
      :editor_tagline,
      :author,
      :hashtags,
      :outside_usa,
      :state,
      :story_year,
      :story_month,
      :story_date,
      :data_entry_begin_time,
      :data_entry_user,
      :desc_length,
      :images,
      :custom_body,
      :internal_image,
      location_ids: [],
      story_category_ids: [],
      place_category_ids: [],
    )
  end
end
