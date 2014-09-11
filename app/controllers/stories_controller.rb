require 'domainatrix'
require 'screen_scraper'
## TODO: not sure why you are requiring the following libraries ?
require 'uri'
require 'socket'
require 'net/http'
require 'net/protocol'

class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :edit, :update, :destroy]

  def scrape
  end

  # GET /stories
  # GET /stories.json
  def index
    @stories = Story.all
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
  end

  # GET /stories/new
  def new
    # parse the domain
    @source_url_pre = params[:source_url_pre]  #grab user input
    if @source_url_pre.present?
      get_domain_info(@source_url_pre)
      @screen_scraper = ScreenScraper.new
      if @screen_scraper.scrape!(@full_web_url)
        @story = Story.new
        @story.urls.build
      else
        # TODO: what if the scrape fails ?  Not handling this gracefully.
      end
    end
    # TODO: what if @source_url_pre is blank or nil ?
  end

  # GET /stories/1/edit
  def edit
  end

  # POST /stories
  # POST /stories.json
  def create
    @story = Story.new(story_params)

    respond_to do |format|
      if @story.save
        format.html { redirect_to @story, notice: 'Story was successfully created.' }
        format.json { render :show, status: :created, location: @story }
      else
        @source_url_pre = @story.urls.first.url_full
        get_domain_info(@source_url_pre)
        @screen_scraper = ScreenScraper.new
        @screen_scraper.scrape!(@full_web_url)
        format.html { render :new }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stories/1
  # PATCH/PUT /stories/1.json
  def update
    respond_to do |format|
      if @story.update(story_params)
        format.html { redirect_to @story, notice: 'Story was successfully updated.' }
        format.json { render :show, status: :ok, location: @story }
      else
        format.html { render :edit }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.json
  def destroy
    @story.destroy
    respond_to do |format|
      format.html { redirect_to stories_url, notice: 'Story was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def get_domain_info(source_url_pre)
    d_url = Domainatrix.parse(source_url_pre)
    @full_domain = d_url.host
    split_full_domain = @full_domain.split(".")
    if split_full_domain.length == 2
      @base_domain = split_full_domain[0].to_s + "." + split_full_domain[1].to_s
    else
      @base_domain = split_full_domain[1].to_s + "." + split_full_domain[2].to_s
    end
    @full_web_url = d_url.url
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_story
    @story = Story.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def story_params
    params.require(:story).permit(
      :media_id, :story_type, :author, :story_month, :story_date, :story_year, :editor_tagline, :location_code,
      urls_attributes: [
        :id, :url_type, :url_full, :url_title, :url_desc, :url_keywords, :url_domain, :primary,
        :url_title_track, :url_desc_track, :url_keywords_track,
        :raw_url_title_scrape, :raw_url_desc_scrape, :raw_url_keywords_scrape
      ]
    )
  end

end
