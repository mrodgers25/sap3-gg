class Admin::PlaceCategoriesController < Admin::BaseAdminController
  before_action :set_category, except: :index
  before_action :check_for_admin, only: :destroy

  def index
    @categories = PlaceCategory.order(created_at: :desc)
    @categories = @categories.where("LOWER(code) ~ ?", params[:code].downcase) if params[:code].present?
    @categories = @categories.where("LOWER(name) ~ ?", params[:name].downcase) if params[:name].present?

    @pagy, @categories = pagy(@categories)
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
