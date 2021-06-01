class Admin::CustomStoriesController < Admin::BaseAdminController
  before_action :set_story, only: [:edit, :update, :destroy_internal_image]
  before_action :get_locations_and_categories, only: [:new, :edit]

  def new
    @story = CustomStory.new
    @story.build_external_image
  end

  def create
    begin
      CustomStory.create!(story_params)
      redirect_to admin_stories_path, notice: 'Story was successfully created.'
    rescue => e
      redirect_to new_admin_custom_story_path, alert: e
    end
  end

  def edit
  end

  def update
    begin
      @story.update!(story_params)
      redirect_to admin_stories_path, notice: 'Story was successfully updated.'
    rescue => e
      redirect_to edit_admin_custom_story_path(@story), alert: e
    end
  end

  def destroy_internal_image
    if @story.internal_image.attached?
      @story.internal_image.purge
      @story.update(internal_image_height: 0, internal_image_width: 0)

      render json: { success: true, message: 'Image was successfully removed.' }
    else
      render json: { success: false, message: 'Error occured' }
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
      :custom_body,
      :internal_image,
      :internal_image_width,
      :internal_image_height,
      location_ids: [],
      story_category_ids: [],
      place_category_ids: [],
      external_image_attributes: [
        :src_url, :width, :height
      ]
    )
  end
end
