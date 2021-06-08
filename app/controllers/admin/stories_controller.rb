class Admin::StoriesController < Admin::BaseAdminController
  before_action :set_story, only: [:show, :destroy, :review, :review_update, :update_state, :places, :places_update, :images, :images_update]
  before_action :check_for_admin, only: :destroy

  def index
    # database dropdown data
    @locations        = Location.order("ascii(name)")
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)

    @stories = Story.joins(:urls).select(
      "stories.*",
      "
        CASE
          WHEN story_year > 0 AND story_month > 0 AND story_date > 0
          THEN TO_DATE(CONCAT(story_year::TEXT, '-', story_month::TEXT, '-', story_date::TEXT), 'YYYY-MM-DD')
          WHEN story_year > 0 AND story_month > 0
          THEN TO_DATE(CONCAT(story_year::TEXT, '-', story_month::TEXT), 'YYYY-MM')
          ELSE null
        END AS story_date_combined
      "
    )
    @stories = @stories.where("LOWER(type) ~ ?", params[:type].downcase) if params[:type].present?
    @stories = @stories.where("LOWER(urls.url_title) ~ ?", params[:url_title].downcase) if params[:url_title].present?
    @stories = @stories.where("LOWER(urls.url_desc) ~ ?", params[:url_desc].downcase) if params[:url_desc].present?
    @stories = @stories.where(state: params[:state]) if params[:state].present?
    @stories = @stories.joins(:locations).where(locations: { id: params[:location_id] }) if params[:location_id].present?
    @stories = @stories.joins(:place_categories).where(place_categories: { id: params[:place_category_id] }) if params[:place_category_id].present?
    @stories = @stories.joins(:story_categories).where(story_categories: { id: params[:story_category_id] }) if params[:story_category_id].present?
    @stories = @stories.order(story_date_combined: :desc)

    @pagy, @stories = pagy(@stories)
  end

  def show
    render layout: "application_no_nav"
  end

  def images
    if @story.media_story?
      @screen_scraper = ScreenScraper.new
      if @screen_scraper.scrape!(@story.urls.first.url_full)
        images = @story.urls.first.images
        images.build(src_url: 'TEMP').save if images.blank?
        @page_imgs = @screen_scraper.page_imgs
      else
        flash.now.alert = "Something went wrong with the scraper."
      end
    elsif @story.video_story?
      @screen_scraper = VideoScraper.new
      if @screen_scraper.scrape!(@story.urls.first.url_full)
        images = @story.urls.first.images
        images.build(src_url: 'TEMP').save if images.blank?
        @page_imgs = [{
              'src_url' => @screen_scraper.link_image,
              'alt_text' => 'Thumbnail',
              'image_width' => '1280',
              'image_height' => '720'
            }]
      else
        flash.now.alert = "Something went wrong with the scraper."
      end
    end
  end

  def images_update
    my_params = set_image_params(story_params)
    if @story.update(my_params)
      redirect_to redirect_to_next_path(places_admin_story_path(@story)), notice: 'Image was successfully updated.'
    else
      render :images
    end
  end

  def places
    get_locations_and_categories
  end

  def places_update
    get_locations_and_categories
    if @story.update(story_places_params)
      new_place_categories = PlaceCategory.find(story_places_params[:place_category_ids].reject{|p| p.empty?}.map{|p| p.to_i})
      @story.place_categories = new_place_categories
      redirect_to redirect_to_next_path(review_admin_story_path(@story)), notice: 'Places were successfully updated.'
    else
      render :places
    end
  end

  def review
  end

  def review_update
    if @story.update(review_update_params)
      redirect_to review_admin_story_path(@story)
    else
      redirect_to review_admin_story_path(@story), notice: 'Story failed to be updated.'
    end
  end

  def approve
    if @story.approve!
      redirect_to admin_stories_path, notice: "Story has been approved!"
    else
      redirect_to admin_stories_path, alert: "Story has NOT been approved."
    end
  end

  def update_state
    begin
      case update_state_params[:state]
      when 'needs_review'
        @story.request_review!
      when 'do_not_publish'
        @story.hide!
      when 'completed'
        @story.complete!
      when 'removed_from_public'
        @story.remove!
      when 'no_status'
        @story.reset!
      end

      redirect_route = params[:commit] == 'Save & New' ? admin_initialize_scraper_index_path : admin_stories_path

      redirect_to redirect_route, notice: "Story saved as #{update_state_params[:state].titleize}"
    rescue
      redirect_to review_admin_story_path(@story), alert: 'Story failed to update'
    end
  end

  def destroy
    if @story.destroy
      redirect_to admin_stories_path, notice: 'Story was successfully destroyed.'
    else
      redirect_to admin_stories_path, alert: 'Story could not be destroyed.'
    end
  end

  def bulk_index
    @stories = Story.select(
      "stories.*",
      "
        CASE
          WHEN story_year > 0 AND story_month > 0 AND story_date > 0
          THEN TO_DATE(CONCAT(story_year::TEXT, '-', story_month::TEXT, '-', story_date::TEXT), 'YYYY-MM-DD')
          WHEN story_year > 0 AND story_month > 0
          THEN TO_DATE(CONCAT(story_year::TEXT, '-', story_month::TEXT), 'YYYY-MM')
          ELSE null
        END AS story_date_combined
      "
    )
    @stories = @stories.joins(:urls).where("LOWER(urls.url_full) ~ ?", params[:story_url].downcase) if params[:story_url].present?
    @stories = @stories.joins(urls: :images).where("LOWER(images.src_url) ~ ?", params[:image_url].downcase) if params[:image_url].present?
    @stories = @stories.where("LOWER(stories.author) ~ ?", params[:author].downcase) if params[:author].present?
    # For use in the future
    # @stories = @stories.joins(:authors).where("LOWER(authors.name) ~ ?", params[:author].downcase)) if params[:author].present?
    @stories = @stories.order(story_date_combined: :desc)

    @pagy, @stories = pagy(@stories)
  end

  def bulk_update
    @stories = Story.where(id: bulk_update_params[:ids])
    count    = @stories.size

    if @stories.present?
      begin
        case bulk_update_params[:update_type]
        when "completed"
          action_text = 'moved to completed'
          @stories.each{|story| story.complete! }
        when "needs_review"
          action_text = 'moved to needs review'
          @stories.each{|story| story.request_review! }
        when "do_not_publish"
          action_text = 'moved to do not publish'
          @stories.each{|story| story.hide! }
        when "removed_from_public"
          action_text = 'removed from public'
          @stories.each{|story| story.remove! }
        end

        redirect_to bulk_index_admin_stories_path, notice: "#{count} #{"story".pluralize(count)} #{action_text}."
      rescue => e
        redirect_to bulk_index_admin_stories_path, alert: e
      end
    else
      redirect_to bulk_index_admin_stories_path, alert: "No selection was made."
    end
  end

  private

  def set_story
    begin
      @story = Story.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_stories_path, alert: "Story not found"
    end
  end

  def get_sym_story_type
    if @story.media_story?
      type = 'media_story'.to_sym
    elsif @story.video_story?
      type = 'video_story'.to_sym
    end
  end

  def story_places_params
    params.require(get_sym_story_type).permit(:place_category_ids => [])
  end

  def review_update_params
    params.require(get_sym_story_type).permit(:desc_length, :editor_tagline)
  end

  def update_state_params
    params.require(get_sym_story_type).permit(:state)
  end

  def bulk_update_params
    params.permit(:update_type, ids: [])
  end

  def get_locations_and_categories
    @locations        = Location.order("ascii(name)")
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)
  end

  def story_params
    params.require(get_sym_story_type).permit(
      urls_attributes:  [:id, images_attributes: [:id, :src_url, :alt_text, :image_data, :manual_url, :image_width, :image_height, :manual_enter]])
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

  def redirect_to_next_path(path)
    if params[:commit] == 'Save & New'
      admin_initialize_scraper_index_path
    elsif params[:commit] == 'Save & Exit'
      admin_stories_path
    else
      path
    end
  end
end
