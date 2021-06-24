class Admin::AddressesController < Admin::BaseAdminController
  before_action :set_address, except: %i[index new create]
  before_action :check_for_admin, only: :destroy
  
  def index
    @addresses = Address.order(created_at: :desc)
    @pagy, @addresses = pagy(@addresses)
  end

  def show
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)

    if @address.save
      redirect_to admin_address_path(@address), notice: 'Successfully created Address.'
    else
      redirect_to new_admin_address_path, alert: 'Could not create Address.'
    end
  end

  def edit 
  end

  def update
    if @address.update(address_params)
      redirect_to admin_address_path(@address), notice: 'Successfully updated Address.'
    else
      redirect_to admin_address_path(@address), alert: 'Could not update Address.'
    end
  end

  def destroy
    if @address.destroy
      redirect_to admin_addresses_path, notice: 'Successfully destroyed Address.'
    else
      redirect_to admin_addresses_path, alert: 'Could not destroy Address.'
    end
  end

  private

  def set_address
    @address = Address.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_addresses_path
  end

  def address_params
    params.require(:address).permit!
  end

end