class Admin::CodesController < Admin::BaseAdminController
  before_action :set_code, except: :index
  before_action :check_for_admin, only: :destroy

  def index
    @codes = Code.order(created_at: :desc)
    @codes = @codes.where("LOWER(code_type) ~ ?", params[:code_type].downcase) if params[:code_type].present?
    @codes = @codes.where("LOWER(code_key) ~ ?", params[:code_key].downcase) if params[:code_key].present?
    @codes = @codes.where("LOWER(code_value) ~ ?", params[:code_value].downcase) if params[:code_value].present?

    @pagy, @codes = pagy(@codes)
  end

  def edit
  end

  def update
    if @code.update(code_params)
      redirect_to edit_admin_code_path(@code), notice: "Successfully updated Code."
    else
      redirect_to edit_admin_code_path(@code), alert: "Could not update Code."
    end
  end

  def destroy
    if @code.destroy
      redirect_to admin_codes_path, notice: "Successfully destroyed Code."
    else
      redirect_to admin_codes_path, alert: "Could not destroy Code."
    end
  end

  private

  def set_code
    begin
      @code = Code.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_codes_path
    end
  end

  def code_params
    params.require(:code).permit(:code_type, :code_key, :code_value)
  end
end
