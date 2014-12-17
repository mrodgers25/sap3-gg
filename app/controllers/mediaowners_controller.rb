class MediaownersController < ApplicationController
  before_action :set_mediaowner, only: [:show, :edit, :update, :destroy]
  respond_to :js, :html

  def index
    @mediaowners = Mediaowner.order("title").all
    respond_with(@mediaowners)
  end

  def show
    respond_with(@mediaowner)
  end

  def new
    @mediaowner = Mediaowner.new
    respond_with(@mediaowner)
  end

  def edit
  end

  def create
    @mediaowner = Mediaowner.new(mediaowner_params)
    @mediaowner.save
    respond_with(@mediaowner)
  end

  def update
    @mediaowner.update(mediaowner_params)
    respond_with(@mediaowner)
  end

  def destroy
    @mediaowner.destroy
    respond_with(@mediaowner)
  end

  private
    def set_mediaowner
      @mediaowner = Mediaowner.find(params[:id])
    end

    def mediaowner_params
      params.require(:mediaowner).permit(:title, :url, :url_domain, :owner_name, :media_type, :distribution_type, :publication_name, :paywall_yn, :content_frequency_time, :content_frequency_other, :content_frequency_guide, :nextissue_yn)
    end
end
