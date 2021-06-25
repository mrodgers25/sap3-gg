class Admin::StoryRegionsController < Admin::BaseAdminController
  before_action :set_story_region, except: [:index, :new, :create]
  before_action :check_for_admin, only: :destroy

  def index
    @story_regions = StoryRegion.order(created_at: :desc)
    @story_regions = @story_regions.where("LOWER(code) ~ ?", params[:code].downcase) if params[:code].present?
    @story_regions = @story_regions.where("LOWER(name) ~ ?", params[:name].downcase) if params[:name].present?

    @pagy, @story_regions = pagy(@story_regions)
  end

  def new
    @story_region = StoryRegion.new
  end

  def create
    @story_region = StoryRegion.new(story_region_params)

    if @story_region.save
      redirect_to admin_story_regions_path, notice: "Successfully created Story Region."
    else
      redirect_to admin_story_regions_path, alert: "Could not create Story Region."
    end
  end

  def edit
  end

  def update
    if @story_region.update(story_region_params)
      redirect_to edit_admin_story_region_path(@story_region), notice: "Successfully updated Story Region."
    else
      redirect_to edit_admin_story_region_path(@story_region), alert: "Could not update Story Region."
    end
  end

  def destroy
    if @story_region.destroy
      redirect_to admin_story_regions_path, notice: "Successfully destroyed Story Region."
    else
      redirect_to admin_story_regions_path, alert: "Could not destroy Story Region."
    end
  end

  private

  def set_story_region
    begin
      @story_region = StoryRegion.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_story_regions_path
    end
  end

  def story_region_params
    params.require(:story_region).permit(:code, :name)
  end
end
