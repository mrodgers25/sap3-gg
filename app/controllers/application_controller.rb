class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  protected

  def configure_devise_permitted_parameters
    registration_params = [:first_name, :last_name, :city_preference, :email, :password, :password_confirmation]

    if params[:action] == 'update'
      devise_parameter_sanitizer.permit(:account_update, keys: registration_params << :current_password)
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.permit(:sign_up, keys: registration_params)
    end
  end

  private

  def allow_iframe
    response.headers.delete "X-Frame-Options"
  end

  def filter_out_file_types_from_url
    # Try to remove the amount of bad requests by filtering out file types
    redirect_to root_path if request.url.match? /.txt|.png|.xml|.php|.woff2|.json|click?/
  end
end
