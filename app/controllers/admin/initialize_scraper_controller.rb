class Admin::InitializeScraperController < Admin::BaseAdminController

  def index
  end

  def scrape
    @data_entry_begin_time = params[:data_entry_begin_time]
    @source_url_pre        = params[:source_url_pre]
    if @source_url_pre.include?('www.youtube.com')
      redirect_to scrape_admin_video_stories_path(source_url_pre: @source_url_pre , data_entry_begin_time: @data_entry_begin_time)
    else
      redirect_to scrape_admin_stories_path(source_url_pre: @source_url_pre , data_entry_begin_time: @data_entry_begin_time)
    end
  end
end
