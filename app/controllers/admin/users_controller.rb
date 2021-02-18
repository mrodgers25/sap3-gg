class Admin::UsersController < Admin::BaseAdminController
  before_action :set_user, except: :index
  before_action :check_for_admin, only: [:update, :destroy]

  def index
    @users = User.order(created_at: :desc)
    @users = @users.where("LOWER(first_name) ~ ?", params[:first_name].downcase) if params[:first_name].present?
    @users = @users.where("LOWER(last_name) ~ ?", params[:last_name].downcase) if params[:last_name].present?
    @users = @users.where("LOWER(email) ~ ?", params[:email].downcase) if params[:email].present?
    @users = @users.where("LOWER(city_preference) ~ ?", params[:city_preference].downcase) if params[:city_preference].present?
    @users = @users.where(role: params[:role]) if params[:role].present?

    @pagy, @users = pagy(@users)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to edit_admin_user_path(@user), notice: "Successfully updated User."
    else
      redirect_to edit_admin_user_path(@user), alert: "Could not update User."
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice: "Successfully destroyed User."
    else
      redirect_to admin_users_path, alert: "Could not destroy User."
    end
  end

  private

  def set_user
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_users_path
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :city_preference)
  end
end
