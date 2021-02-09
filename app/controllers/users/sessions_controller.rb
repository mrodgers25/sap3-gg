# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  layout 'application_no_nav'
  before_action :configure_sign_in_params, only: [:create]

  def create
    super
    # Remove devise flash notifications
    flash.delete(:notice)
  end

  def destroy
    super
    # Remove devise flash notifications
    flash.delete(:notice)
  end

  protected

  def after_sign_in_path_for(resource)
    root_path
  end

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :remember_me])
  end
end
