class Admin::AdminSettingsController < Admin::BaseAdminController
  before_action :set_admin_setting, except: :index

  def index
    @admin_setting = AdminSetting.first
  end

  def update
    if @admin_setting.update(admin_settings_params)
      redirect_to admin_admin_settings_path, notice: 'Admin Setting was successfully updated.'
    else
      redirect_to admin_admin_settings_path, alert: 'Admin Setting failed to be updated.'
    end
  end

  private

  def set_admin_setting
    begin
      @admin_setting = AdminSetting.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_admin_settings_path, alert: 'Admin Setting not found.'
    end
  end

  def admin_settings_params
    params.require(:admin_setting).permit(:newsfeed_display_limit, :filtered_display_limit, :newsfeed_daily_post_count)
  end
end
