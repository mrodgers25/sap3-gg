class Admin::LocationsController < Admin::BaseAdminController
  before_action :set_location, except: [:index, :new, :create]
  before_action :check_for_admin, only: :destroy

  def index
    @locations = Location.order(created_at: :desc)
    @locations = @locations.where("LOWER(code) ~ ?", params[:code].downcase) if params[:code].present?
    @locations = @locations.where("LOWER(name) ~ ?", params[:name].downcase) if params[:name].present?

    @pagy, @locations = pagy(@locations)
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)

    if @location.save
      redirect_to admin_locations_path, notice: "Successfully created Location."
    else
      redirect_to admin_locations_path, alert: "Could not create Location."
    end
  end

  def edit
  end

  def update
    if @location.update(location_params)
      redirect_to edit_admin_location_path(@location), notice: "Successfully updated Location."
    else
      redirect_to edit_admin_location_path(@location), alert: "Could not update Location."
    end
  end

  def destroy
    if @location.destroy
      redirect_to admin_locations_path, notice: "Successfully destroyed Location."
    else
      redirect_to admin_locations_path, alert: "Could not destroy Location."
    end
  end

  private

  def set_location
    begin
      @location = Location.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_locations_path
    end
  end

  def location_params
    params.require(:location).permit(:code, :name)
  end
end
