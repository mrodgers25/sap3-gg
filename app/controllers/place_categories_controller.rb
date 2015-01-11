class PlaceCategoriesController < ApplicationController
  before_action :set_place_category, only: [:show, :edit, :update, :destroy]

  # GET /place_categories
  # GET /place_categories.json
  def index
    @place_categories = PlaceCategory.all.order(:name)
  end

  # GET /place_categories/1
  # GET /place_categories/1.json
  def show
  end

  # GET /place_categories/new
  def new
    @place_category = PlaceCategory.new
  end

  # GET /place_categories/1/edit
  def edit
  end

  # POST /place_categories
  # POST /place_categories.json
  def create
    @place_category = PlaceCategory.new(place_category_params)

    respond_to do |format|
      if @place_category.save
        format.html { redirect_to @place_category, notice: 'Place category was successfully created.' }
        format.json { render :show, status: :created, location: @place_category }
      else
        format.html { render :new }
        format.json { render json: @place_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /place_categories/1
  # PATCH/PUT /place_categories/1.json
  def update
    respond_to do |format|
      if @place_category.update(place_category_params)
        format.html { redirect_to @place_category, notice: 'Place category was successfully updated.' }
        format.json { render :show, status: :ok, location: @place_category }
      else
        format.html { render :edit }
        format.json { render json: @place_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /place_categories/1
  # DELETE /place_categories/1.json
  def destroy
    @place_category.destroy
    respond_to do |format|
      format.html { redirect_to place_categories_url, notice: 'Place category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place_category
      @place_category = PlaceCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def place_category_params
      params[:place_category].permit(:code, :name)
    end
end
