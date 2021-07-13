module Admin
  class CategoriesController < Admin::BaseAdminController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
    @pagy, @categories = pagy(@categories)
  end

  def show
      @places = Place.where(category_id: @category.id) if @category.reference == "place"
  end

  def new
    @category = Category.new(parent_id: params[:parent_id])
  end

  def get_subcategories
    category = Category.find(params[:category_id])
    render json: category.children
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    unless @category.save 
     flash[:alert] = @category.errors
     redirect_to new_admin_category_path
    end
    redirect_to admin_categories_path
  end


  def update
    unless @category.update(category_params)
      flash[:alert] = "Could not update category"
      redirect_to admin_category_path(@category)
    end
    redirect_to admin_categories_path
  end


  def destroy
    @category.destroy
    redirect_to admin_categories_path
  end

  private
  
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit!
    end
  end
end
