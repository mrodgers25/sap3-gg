# frozen_string_literal: true

module Admin
  class UrlsController < Admin::BaseAdminController
    before_action :set_url, except: :index
    before_action :check_for_admin, only: :destroy

    def index
      @urls = Url.order(created_at: :desc)
      @urls = @urls.where('LOWER(url_full) ~ ?', params[:search].downcase) if params[:search].present?

      @pagy, @urls = pagy(@urls)
    end

    def edit; end

    def update
      if @url.update(url_params)
        redirect_to edit_admin_url_path(@url), notice: 'Successfully updated Url.'
      else
        redirect_to edit_admin_url_path(@url), alert: 'Could not update Url.'
      end
    end

    def destroy
      if @url.destroy
        redirect_to admin_urls_path, notice: 'Successfully destroyed Url.'
      else
        redirect_to admin_urls_path, alert: 'Could not destroy Url.'
      end
    end

    private

    def set_url
      @url = Url.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_urls_path
    end

    def url_params
      params.require(:url).permit(:id, :url_type, :url_full, :url_title, :url_desc, :url_keywords, :url_domain, :primary,
                                  :url_title_track, :url_desc_track, :url_keywords_track,
                                  :raw_url_title_scrape, :raw_url_desc_scrape, :raw_url_keywords_scrape)
    end
  end
end
