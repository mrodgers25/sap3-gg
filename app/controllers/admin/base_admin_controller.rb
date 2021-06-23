class Admin::BaseAdminController < ApplicationController
  include Pagy::Backend
  layout 'application'

  before_action :authenticate_user!
  before_action :check_for_role

  private

  def check_for_role
    redirect_to root_path unless current_user.is_role?(:admin) || current_user.is_role?(:associate)
  end

  def check_for_admin
    redirect_to :admin_stories_path unless current_user.is_role?(:admin)
  end
end
