class UsersController < ApplicationController
  before_action :set_user
  before_action :remove_empty_password_fields, only: :update
  before_action :check_for_valid_password, only: :update

  layout "application_v2"

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to edit_user_path(@user), notice: "User updated."
    else
      redirect_to edit_user_path(@user), alert: "Unable to update User."
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, city_preference: [])
  end

  def remove_empty_password_fields
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?
  end

  def check_for_valid_password
    return unless user_params[:password].present? || user_params[:password_confirmation].present?

    if user_params[:password] != user_params[:password_confirmation]
      redirect_to edit_user_path(@user), alert: 'Your password and password confirmation do not match'
    end
  end
end
