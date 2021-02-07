require 'domainatrix'
require 'screen_scraper'
## TODO: not sure why you are requiring the following libraries ?
require 'uri'
require 'socket'
require 'net/http'
require 'net/protocol'

class Admin::StoriesController < Admin::BaseAdminController

  before_action :set_story, only: [:save_story, :forget_story, :show, :edit, :update, :destroy]
  before_action :check_for_admin, only: :destroy

  def scrape
  end

  def index
     # database dropdown data
    @locations        = Location.order("ascii(name)")
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)

    @stories = Story.includes(:urls)
    @stories = @stories.joins(:locations).where("locations.id = #{params[:location_id]}") if params[:location_id].present?
    @stories = @stories.joins(:place_categories).where("place_categories.id = #{params[:place_category_id]}") if params[:place_category_id].present?
    @stories = @stories.joins(:story_categories).where("story_categories.id = #{params[:story_category_id]}") if params[:story_category_id].present?
    @stories = @stories.order('created_at DESC')

    @pagy, @stories = pagy(@stories)
  end

  def incomplete
    @stories = Story.joins(:urls).order("stories.id DESC").where(story_complete: false).includes(:urls)
  end

  def sequence
    @stories = Story.joins(:urls).order("stories.release_seq, stories.updated_at").where(story_complete: true, sap_publish_date: nil).includes(:urls)

    # resequence on form start
    seq = 1
    @stories.each do |s|
      s.update_attributes(release_seq: seq)
      seq += 1
    end
  end

  def edit_seq
    @story = Story.find(params[:id])
    @urls = @story.urls
    @url_title = @urls.last.url_title
    @sequence = @story.release_seq
  end

  def pub_now
    Story.find(params[:id]).update_attributes(sap_publish_date: Time.now)
    redirect_to root_path, notice: 'Story was successfully published.'
  end

  def show
    @story = Story.find(params[:id])
    @urls = @story.urls
    @images = @urls.first.images
  end

  def story_proof
    @story = Story.find(params[:id])
    @urls = @story.urls
    @images = @urls.first.images
  end

  def new
    # parse the domain
    @data_entry_begin_time = params[:data_entry_begin_time]  #grab user input
    @source_url_pre = params[:source_url_pre]  #grab user input
    if @source_url_pre.present?
      get_locations_and_categories
      get_domain_info(@source_url_pre)
      @screen_scraper = ScreenScraper.new
      if @screen_scraper.scrape!(@full_web_url)
        @story = Story.new
        url = @story.urls.build
        url.images.build
        set_scrape_fields
        #binding.pry
      else
        flash.now.alert = "We can't find that URL – give it another shot"
        render :scrape
      end
    else
      flash.now.alert = "You have to enter a URL for this to work"
      render :scrape
    end
  end

  def create
    # TODO:  check_manual_url(params)
    my_params = set_image_params(story_params)
    @story = Story.new(my_params)

    respond_to do |format|
      if @story.save
        update_locations_and_categories(@story, story_params)
        format.html { redirect_to story_proof_url(@story), notice: 'Story was successfully created.' }
        format.json { render :show, status: :created, location: @story }
      else
        @source_url_pre = params["story"]["urls_attributes"]["0"]["url_full"]
        get_domain_info(@source_url_pre)
        set_fields_on_fail(story_params)
        get_locations_and_categories
        format.html { render :new }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
    #This script is used to update the permalink field in all stories
      url_title = @story.urls.first.url_title.parameterize
      rand_hex = SecureRandom.hex(2)
      permalink = "#{rand_hex}/#{url_title}"
      @story.update_attribute(:permalink, "#{permalink}")
  end

  def edit
    @story = Story.find(params[:id])
    @previous = Story.where("id < ?", params[:id]).order(:id).last
    @next = Story.where("id > ?", params[:id]).order(:id).first
    @meta_tagline = @story.editor_tagline  # story fields
    @tagline_complete = (@meta_tagline.present? ? 'complete' : 'incomplete')
    # @meta_location = @story.location_code
    # @meta_place = @story.place_category
    # @meta_story_category = @story.story_category
    @meta_type = @story.scraped_type
    @meta_author = @story.author
    @outside_usa = @story.outside_usa
    @year = @story.story_year
    @month = @story.story_month
    @day = @story.story_date
    @date_complete = ( (@year.present? || @month.present? || @day.present?) ? 'complete' : 'incomplete')
    @story_complete = @story.story_complete

    @url1 = @story.urls.first  # url fields
    @source_url_pre = @url1.url_full
    @base_domain = @url1.url_domain
    if Mediaowner.where(url_domain: @base_domain).first.present?
      @name_display =  Mediaowner.where(url_domain: @base_domain).first.title
    else
      @name_display = 'NO DOMAIN NAME FOUND'
    end
    @title = @url1.url_title
    @title_complete = (@title.present? ? 'complete' : 'incomplete')
    @meta_desc = @url1.url_desc
    @desc_complete = (@meta_desc.present? ? 'complete' : 'incomplete')
    @meta_keywords = @url1.url_keywords
    @full_web_url = @url1.url_full

    @image1 = @url1.images.first  # image fields
    @page_imgs = [{'src_url' => @image1.src_url, 'alt_text' => @image1.alt_text, 'image_width' => @image1.image_width, 'image_height' => @image1.image_height}]
    get_locations_and_categories
    @selected_location_ids = @story.locations.map(&:id)
    @selected_place_category_ids = @story.place_categories.map(&:id)
    @pc_complete = (@selected_place_category_ids.present? ? 'complete' : 'incomplete')
    @selected_story_category_ids = @story.story_categories.map(&:id)
  end

  def update
    respond_to do |format|
      # TODO: if you have params[:manual_url], you may need to get out and verify the image exists
      #       if it does not exist return an error
      #       if it does exist, get the src_url and alt_text and nest them into story_params properly
      if @story.update(story_params)
        if params[:source_action] != 'edit_seq'
          update_locations_and_categories(@story, story_params)
          format.html { redirect_to @story, notice: 'Story was successfully updated.' }
          format.json { render :show, status: :ok, location: @story }
        else
          set_release_seq
          format.html { redirect_to sequence_stories_path, notice: 'Sequence was successfully updated.' }
        end
      else
        get_locations_and_categories
        format.html { render :edit }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize Story
    @story.destroy
    respond_to do |format|
      format.html { redirect_to stories_url, notice: 'Story was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_release_seq
    new_seq = Story.find(params[:id]).release_seq
    old_seq = params[:old_seq].to_i
    if new_seq <= old_seq
      Story.find(params[:id]).update_attributes(release_seq: (new_seq - 1))
    end
    @stories = Story.joins(:urls).order("stories.release_seq, stories.updated_at").where(story_complete: true, sap_publish_date: nil).includes(:urls)
    seq = 1
    @stories.each do |s|
      s.update_attributes(release_seq: seq)
      seq += 1
    end
  end

  # def set_release_seq   ! this reversed seq the unsequenced stories when moving story in one direction
  #   new_seq = Story.find(params[:id]).release_seq
  #   if new_seq >= params[:old_seq].to_i
  #     @stories = Story.joins(:urls).order("stories.release_seq, stories.updated_at").where(story_complete: true, sap_publish_date: nil).includes(:urls)
  #   else
  #     @stories = Story.joins(:urls).order("stories.release_seq, stories.updated_at DESC").where(story_complete: true, sap_publish_date: nil).includes(:urls)
  #   end
  #   seq = 1
  #   @stories.each do |s|
  #     s.update_attributes(release_seq: seq)
  #     seq += 1
  #   end
  # end
  #

  def get_domain_info(source_url_pre)

    full_url = Domainatrix.parse(source_url_pre).url
    sub = Domainatrix.parse(source_url_pre).subdomain
    domain = Domainatrix.parse(source_url_pre).domain
    suffix = Domainatrix.parse(source_url_pre).public_suffix
    prefix = (sub == 'www' || sub == '' ? '' : (sub + '.'))
    @base_domain = prefix + domain + '.' + suffix
    # binding.pry

    # d_url = Domainatrix.parse(source_url_pre)
    # @full_domain = d_url.host
    # split_full_domain = @full_domain.split(".")
    # if split_full_domain.length == 2
    #   @base_domain = split_full_domain[0].to_s + "." + split_full_domain[1].to_s
    # else
    #   @base_domain = split_full_domain[1].to_s + "." + split_full_domain[2].to_s
    # end

    if Mediaowner.where(url_domain: @base_domain).first.present?
      @name_display =  Mediaowner.where(url_domain: @base_domain).first.title
    else
      @name_display = 'NO DOMAIN NAME FOUND'
    end
    @full_web_url = full_url
  end

  private

  def check_for_admin
    redirect_to :admin_stories_path unless current_user.is_role?(:admin)
  end

  def set_story
    @story = Story.find(params[:id])
  end

  def set_scrape_fields
    @title = @screen_scraper.title
    @meta_desc = @screen_scraper.meta_desc
    @meta_keywords = @screen_scraper.meta_keywords
    @meta_type = @screen_scraper.meta_type
    @meta_author = @screen_scraper.meta_author
    @year = @screen_scraper.year
    @month = @screen_scraper.month
    @day = @screen_scraper.day
    @page_imgs = @screen_scraper.page_imgs

    @itemprop_pub_date_match

  end

  def set_fields_on_fail(hash)
    @title = hash['urls_attributes']['0']['url_title']
    @meta_desc = hash['urls_attributes']['0']['url_desc']
    @meta_keywords = hash['urls_attributes']['0']['url_keywords']
    @meta_tagline = hash["editor_tagline"]
    @meta_type = hash["story_type"]
    @meta_author = hash["author"]
    @year = hash["story_year"]
    @month = hash["story_month"]
    @day = hash["story_date"]
    @page_imgs = []
    params['image_src_cache'].try(:each) do |key, src_url|  # in case hidden field hash is nil, added try
      @page_imgs << { 'src_url' => src_url, 'alt_text' => params['image_alt_text_cache'][key] }
    end
    @selected_location_ids = process_chosen_params(hash['location_ids'])
    @selected_place_category_ids = process_chosen_params(hash['place_category_ids'])
    @selected_story_category_ids = process_chosen_params(hash['story_category_ids'])
  end

  def set_image_params(story_params)
    image_data = story_params["urls_attributes"]["0"]["images_attributes"]["0"]["image_data"]

    unless image_data.nil?
      image_data_hash = JSON.parse(image_data)
      story_params["urls_attributes"]["0"]["images_attributes"]["0"]["src_url"] = image_data_hash["src_url"]
      story_params["urls_attributes"]["0"]["images_attributes"]["0"]["alt_text"]= image_data_hash["alt_text"]
      story_params["urls_attributes"]["0"]["images_attributes"]["0"]["image_width"] = image_data_hash["image_width"]
      story_params["urls_attributes"]["0"]["images_attributes"]["0"]["image_height"]= image_data_hash["image_height"]
    end

    story_params
  end

  def get_locations_and_categories
    @locations = Location.order(:name)
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)
  end

  def update_locations_and_categories(story, my_params)
    new_locations = Location.find(process_chosen_params(my_params[:location_ids]))
    story.locations = new_locations

    new_place_categories = PlaceCategory.find(process_chosen_params(my_params[:place_category_ids]))
    story.place_categories = new_place_categories

    new_story_categories = StoryCategory.find(process_chosen_params(my_params[:story_category_ids]))
    story.story_categories = new_story_categories
  end

  def process_chosen_params(my_params)
    if my_params.present?
      my_params.reject{|p| p.empty?}.map{|p| p.to_i}
    end
  end

  def story_params
    params.require(:story).permit(
      :media_id, :scraped_type, :story_type, :author, :outside_usa, :story_year, :story_month, :story_date, :sap_publish_date,
      :editor_tagline, :raw_author_scrape, :raw_story_year_scrape,
      :raw_story_month_scrape, :raw_story_date_scrape, :data_entry_begin_time, :data_entry_user, :story_complete,
      :release_seq,
      :location_ids => [],
      :place_category_ids => [],
      :story_category_ids => [],
      urls_attributes: [
        :id, :url_type, :url_full, :url_title, :url_desc, :url_keywords, :url_domain, :primary, :story_id,
        :url_title_track, :url_desc_track, :url_keywords_track,
        :raw_url_title_scrape, :raw_url_desc_scrape, :raw_url_keywords_scrape,
            images_attributes: [:id, :src_url, :alt_text, :image_data, :manual_url, :image_width, :image_height, :manual_enter]])
  end

end
