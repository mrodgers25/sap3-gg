class Admin::PublishedItemsController < Admin::BaseAdminController
  before_action :set_published_item, only: [:display, :unpublish, :edit, :update, :add_to_queue]

  def index
    @locations        = Location.order("ascii(name)")
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)

    @published_items = PublishedItem.joins("
      INNER JOIN stories ON (publishable_type = 'Story' AND stories.id = publishable_id)
      LEFT JOIN urls ON urls.story_id = stories.id
      LEFT JOIN stories_users ON stories_users.story_id = stories.id
      LEFT JOIN story_locations ON story_locations.story_id = stories.id
      LEFT JOIN locations ON locations.id = story_locations.location_id
      LEFT JOIN story_place_categories ON story_place_categories.story_id = stories.id
      LEFT JOIN place_categories ON place_categories.id = story_place_categories.place_category_id
      LEFT JOIN story_story_categories ON story_story_categories.story_id = stories.id
      LEFT JOIN story_categories ON story_categories.id = story_story_categories.story_category_id
    ").select(
      'published_items.*',
      'stories.type AS story_type',
      "
        CASE
          WHEN stories.story_year > 0 AND stories.story_month > 0 AND stories.story_date > 0
          THEN TO_DATE(CONCAT(stories.story_year::TEXT, '-', stories.story_month::TEXT, '-', stories.story_date::TEXT), 'YYYY-MM-DD')
          WHEN stories.story_year > 0 AND stories.story_month > 0
          THEN TO_DATE(CONCAT(stories.story_year::TEXT, '-', stories.story_month::TEXT), 'YYYY-MM')
          ELSE null
        END AS story_date_combined
      "
    )
    @published_items = @published_items.where(state: 'displaying')
    @published_items = @published_items.where("LOWER(urls.url_title) ~ ?", params[:url_title].downcase) if params[:url_title].present?
    @published_items = @published_items.where("LOWER(urls.url_desc) ~ ?", params[:url_desc].downcase) if params[:url_desc].present?
    @published_items = @published_items.where("stories.type ~ ?", params[:story_type]) if params[:story_type].present?
    @published_items = @published_items.where(locations: {id: params[:location_id]}) if params[:location_id].present?
    @published_items = @published_items.where(place_categories: {id: params[:place_category_id]}) if params[:place_category_id].present?
    @published_items = @published_items.where(story_categories: {id: params[:story_category_id]}) if params[:story_category_id].present?
    @published_items = @published_items.distinct
    @published_items = @published_items.order(story_date_combined: :desc)

    @pagy, @published_items = pagy(@published_items)
  end

  def add_to_queue
    if @published_item.queue!
      redirect_to admin_published_items_path, notice: 'Published Item was successfully added to the queue.'
    else
      redirect_to admin_published_items_path, alert: 'Published Item failed to be queued.'
    end
  end

  def display
    if @published_item.post!
      redirect_to admin_published_items_path, notice: 'Published Item was successfully displayed.'
    else
      redirect_to admin_published_items_path, alert: 'Published Item failed to be displayed.'
    end
  end

  def unpublish
    if @published_item.publishable.remove!
      redirect_to admin_published_items_path, notice: 'Published Item was successfully unpublished.'
    else
      redirect_to admin_published_items_path, alert: 'Published Item failed to be unpublished.'
    end
  end

  def edit
  end

  def update
    if @published_item.update(update_params)
      redirect_to admin_published_items_path, notice: 'Published Item was successfully updated.'
    else
      redirect_to admin_published_items_path, alert: 'Published Item failed to be updated.'
    end
  end

  private

  def set_published_item
    begin
      @published_item = PublishedItem.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_published_items_path, alert: 'Published Item not found.'
    end
  end

  def bulk_update_params
    params.permit(:update_type, ids: [])
  end

  def update_params
    params.require(:published_item).permit(:clear_at, :pinned, :pinned_action)
  end
end
