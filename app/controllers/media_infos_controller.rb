class MediaInfosController < ApplicationController
  before_action :set_media_info, only: [:show, :edit, :update, :destroy]

  # GET /media_infos
  # GET /media_infos.json
  def index
    @media_infos = MediaInfo.all
  end

  # GET /media_infos/1
  # GET /media_infos/1.json
  def show
  end

  # GET /media_infos/new
  def new
    @media_info = MediaInfo.new
  end

  # GET /media_infos/1/edit
  def edit
  end

  # POST /media_infos
  # POST /media_infos.json
  def create
    @media_info = MediaInfo.new(media_info_params)

    respond_to do |format|
      if @media_info.save
        format.html { redirect_to @media_info, notice: 'Media info was successfully created.' }
        format.json { render :show, status: :created, location: @media_info }
      else
        format.html { render :new }
        format.json { render json: @media_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /media_infos/1
  # PATCH/PUT /media_infos/1.json
  def update
    respond_to do |format|
      if @media_info.update(media_info_params)
        format.html { redirect_to @media_info, notice: 'Media info was successfully updated.' }
        format.json { render :show, status: :ok, location: @media_info }
      else
        format.html { render :edit }
        format.json { render json: @media_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /media_infos/1
  # DELETE /media_infos/1.json
  def destroy
    @media_info.destroy
    respond_to do |format|
      format.html { redirect_to media_infos_url, notice: 'Media info was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_media_info
      @media_info = MediaInfo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def media_info_params
      params.require(:media_info).permit(:media_type, :url_id, :media_desc)
    end
end
