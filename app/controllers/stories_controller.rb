class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :edit, :update, :destroy]
  require 'rubygems'
  require 'open-uri'
  require 'uri'
  require 'domainatrix'
  require 'nokogiri'

  def url_show
    @source_url_pre = params[:source_url]  #grab user input
    d_url = Domainatrix.parse(@source_url_pre)
    @dot = "." unless d_url.subdomain.empty?
    @domain = d_url.subdomain + @dot.to_s + d_url.domain + "." + d_url.public_suffix
    @source_url = @domain + d_url.path
    @full_web_url = "http://" + @source_url

    doc = Nokogiri::HTML(open(@full_web_url))  #nokogiri get html;

    rescue SocketError => error
      if retry_attempts > 0
        retry_attempts -= 1
        sleep 5
        retry
      end

    meta_desc_scrape_pre = doc.css("meta[name='description']").first
    @meta_desc_scrape = meta_desc_scrape_pre['content']
    meta_keyword_scrape_pre = doc.css("meta[name='keywords']").first
    @meta_keyword_scrape = meta_keyword_scrape_pre['content']
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
    @story = Story.new
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
    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_params
      params.require(:story).permit(:url_id, :media_id, :story_type, :author, :publication_date, :source_url)
    end
end
