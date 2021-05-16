class Admin::CustomStoriesController < Admin::BaseAdminController
  before_action :set_story, only: [:edit, :update]
  before_action :get_locations_and_categories, only: [:new, :edit]

  def new
    @story = CustomStory.new
  end

  def create
    @story = CustomStory.new(story_params)

    if @story.save
      redirect_to admin_stories_path, notice: 'Story was successfully created.'
    else
      redirect_to edit_admin_custom_story_path(@story), notice: 'Story was not created.'
    end
  end

  def edit
  end

  def update
    if @story.update(story_params)
      redirect_to admin_stories_path, notice: 'Story was successfully updated.'
    else
      redirect_to edit_admin_custom_story_path(@story), notice: 'Story failed to be updated.'
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
end
