class Admin::PlaceCategoriesController < Admin::BaseAdminController
  before_action :set_category, except: [:index, :new, :create]
  before_action :check_for_admin, only: :destroy

  def index
    @categories = PlaceCategory.order(created_at: :desc)
    @categories = @categories.where("LOWER(code) ~ ?", params[:code].downcase) if params[:code].present?
    @categories = @categories.where("LOWER(name) ~ ?", params[:name].downcase) if params[:name].present?

    @pagy, @categories = pagy(@categories)
  end

  def new
    @category = PlaceCategory.new
  end

  def create
    @category = PlaceCategory.new(category_params)

    if @category.save
      redirect_to admin_place_categories_path, notice: "Successfully created Place Category."
    else
      redirect_to admin_place_categories_path, alert: "Could not create Place Category."
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to edit_admin_place_category_path(@category), notice: "Successfully updated Place Category."
    else
      redirect_to edit_admin_place_category_path(@category), alert: "Could not update Place Category."
    end
  end

  def destroy
    if @category.destroy
      redirect_to admin_place_categories_path, notice: "Successfully destroyed Place Category."
    else
      redirect_to admin_place_categories_path, alert: "Could not destroy Place Category."
    end
  end

  private

  def set_category
    begin
      @category = PlaceCategory.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_place_categories_path
    end
  end

  def category_params
    params.require(:place_category).permit(:code, :name)
  end
end
