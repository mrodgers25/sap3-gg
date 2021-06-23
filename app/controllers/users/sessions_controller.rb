# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  layout 'application_no_nav'
  prepend_before_action :check_captcha, only: :create # Change this to be any actions you want to protect.
  before_action :configure_sign_in_params, only: :create

  def create
    super
    # Remove devise flash notifications
    flash.delete(:notice)
  end

  def destroy
    super
    # Remove devise flash notifications
    flash.delete(:notice)
    # clear sidebar state
    session[:sb_closed] = nil
  end

  protected

  def after_sign_in_path_for(_resource)
    root_path
  end

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password remember_me])
  end

  def check_captcha
    return true if Rails.env.development?

    unless verify_recaptcha
      self.resource = resource_class.new sign_in_params
      resource.validate # Look for any other validation errors besides reCAPTCHA
      set_minimum_password_length
      respond_with_navigational(resource) { render :new }
    end
  end
end
