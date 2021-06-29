# frozen_string_literal: true

module Admin
  class LocationsController < Admin::BaseAdminController
    before_action :set_address, except: %i[index new create]
    before_action :check_for_admin, only: :destroy

    def index
      @locations = Location.order(created_at: :desc)
      @pagy, @locations = pagy(@locations)
    end

    def show; end

    def new
      @location = Location.new
    end

    def create
      @location = Location.new(location_params)
      unless @location.save
        flash[:alert] = 'Could not create Location.'
      end
      redirect_to admin_location_path(@location)
    end

    def edit; end

    def update
      unless @location.update(location_params)
        flash[:alert] = 'Could not update Location.'
      end
      redirect_to admin_location_path(@location)
    end

    def destroy
      unless @location.destroy
        flash[:alert] = 'Could not destroy Location.'
      end
      redirect_to admin_locations_path 
    end

    private

    def set_address
      @location = Location.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_locations_path
    end

    def location_params
      params.require(:location).permit!
    end
  end
end
