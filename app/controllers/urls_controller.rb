class UrlsController < ApplicationController
  before_action :set_url, only: [:show, :edit, :update, :destroy]
  # before_action :set_url, only: [:new, :create, :show, :edit, :update, :destroy]

  # GET /urls
  # GET /urls.json
  def index
    @urls = Url.all
  end

  # GET /urls/1
  # GET /urls/1.json
  def show
  end

  # GET /urls/new
  def new
    @url = Url.new
    @url.images.build
  end

  # GET /urls/1/edit
  def edit
  end

  # POST /urls
  # POST /urls.json
  def create
    @url = Url.new(url_params)

    respond_to do |format|
      if @url.save
        format.html { redirect_to @url, notice: 'Url was successfully created.' }
        format.json { render :show, status: :created, location: @url }
      else
        format.html { render :new }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /urls/1
  # PATCH/PUT /urls/1.json
  def update
    respond_to do |format|
      if @url.update(url_params)
        format.html { redirect_to @url, notice: 'Url was successfully updated.' }
        format.json { render :show, status: :ok, location: @url }
      else
        format.html { render :edit }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /urls/1
  # DELETE /urls/1.json
  def destroy
    @url.destroy
    respond_to do |format|
      format.html { redirect_to urls_url, notice: 'Url was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      @url = Url.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def url_params
      params.require(:url).permit(:id, :url_type, :url_full, :url_title, :url_desc, :url_keywords, :url_domain, :primary,
                                  :url_title_track, :url_desc_track, :url_keywords_track,
                                  :raw_url_title_scrape, :raw_url_desc_scrape, :raw_url_keywords_scrape)
    end
end
