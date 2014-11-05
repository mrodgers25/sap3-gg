class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # include ApplicationHelper

  private

  def allow_iframe
    response.headers.delete "X-Frame-Options"
  end

end
