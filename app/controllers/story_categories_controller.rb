class StoryCategoriesController < ApplicationController
  before_action :set_story_category, only: [:show, :edit, :update, :destroy]

  # GET /story_categories
  # GET /story_categories.json
  def index
    @story_categories = StoryCategory.all.order(:name)
  end

  # GET /story_categories/1
  # GET /story_categories/1.json
  def show
  end

  # GET /story_categories/new
  def new
    @story_category = StoryCategory.new
  end

  # GET /story_categories/1/edit
  def edit
  end

  # POST /story_categories
  # POST /story_categories.json
  def create
    @story_category = StoryCategory.new(story_category_params)

    respond_to do |format|
      if @story_category.save
        format.html { redirect_to @story_category, notice: 'Story category was successfully created.' }
        format.json { render :show, status: :created, location: @story_category }
      else
        format.html { render :new }
        format.json { render json: @story_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /story_categories/1
  # PATCH/PUT /story_categories/1.json
  def update
    respond_to do |format|
      if @story_category.update(story_category_params)
        format.html { redirect_to @story_category, notice: 'Story category was successfully updated.' }
        format.json { render :show, status: :ok, location: @story_category }
      else
        format.html { render :edit }
        format.json { render json: @story_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /story_categories/1
  # DELETE /story_categories/1.json
  def destroy
    @story_category.destroy
    respond_to do |format|
      format.html { redirect_to story_categories_url, notice: 'Story category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story_category
      @story_category = StoryCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_category_params
      params[:story_category].permit(:code, :name)
    end
end
