class Admin::PlaceGroupingsController < Admin::BaseAdminController
  before_action :set_grouping, except: [:index, :new, :create]
  before_action :check_for_admin, only: :destroy

  def index
    @groupings = PlaceGrouping.order(created_at: :desc)
    @groupings = @groupings.where("LOWER(code) ~ ?", params[:code].downcase) if params[:code].present?
    @groupings = @groupings.where("LOWER(name) ~ ?", params[:name].downcase) if params[:name].present?

    @pagy, @groupings = pagy(@groupings)
  end

  def new
    @grouping = PlaceGrouping.new
  end

  def create
    @grouping = PlaceGrouping.new(grouping_params)

    if @grouping.save
      redirect_to admin_place_groupings_path, notice: "Successfully created Place Grouping."
    else
      redirect_to admin_place_groupings_path, alert: "Could not create Place Grouping."
    end
  end

  def edit
  end

  def update
    if @grouping.update(grouping_params)
      redirect_to edit_admin_place_grouping_path(@grouping), notice: "Successfully updated Place Grouping."
    else
      redirect_to edit_admin_place_grouping_path(@grouping), alert: "Could not update Place Grouping."
    end
  end

  def destroy
    if @grouping.destroy
      redirect_to admin_place_groupings_path, notice: "Successfully destroyed Place Grouping."
    else
      redirect_to admin_place_groupings_path, alert: "Could not destroy Place Grouping."
    end
  end

  private

  def set_grouping
    begin
      @grouping = PlaceGrouping.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_place_groupings_path
    end
  end

  def grouping_params
    params.require(:place_grouping).permit(:code, :name)
  end
end
