class Admin::PublishedItemsController < Admin::BaseAdminController
  before_action :set_published_item, only: [:display, :unpublish, :edit, :update]

  def index
    @locations        = Location.order("ascii(name)")
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)

    @published_items = PublishedItem.joins("
      INNER JOIN stories ON (publishable_type = 'Story' AND stories.id = publishable_id)
      INNER JOIN urls ON urls.story_id = stories.id
      LEFT JOIN stories_users ON stories_users.story_id = stories.id
      LEFT JOIN story_locations ON story_locations.story_id = stories.id
      LEFT JOIN locations ON locations.id = story_locations.location_id
      LEFT JOIN story_place_categories ON story_place_categories.story_id = stories.id
      LEFT JOIN place_categories ON place_categories.id = story_place_categories.place_category_id
      LEFT JOIN story_story_categories ON story_story_categories.story_id = stories.id
      LEFT JOIN story_categories ON story_categories.id = story_story_categories.story_category_id
    ").select(
      'published_items.*',
      'published_items.created_at AS completed_at',
      "
        CASE
        WHEN published_items.state = 'newsfeed' AND published_items.pinned = true THEN 1
        WHEN published_items.state = 'newsfeed' AND published_items.pinned IS NOT TRUE THEN 2
        WHEN published_items.state = 'queued' THEN 3
        WHEN published_items.state = 'displaying' THEN 4
        END AS state_order
      "
    )
    @published_items = @published_items.where("LOWER(urls.url_title) ~ ?", params[:url_title].downcase) if params[:url_title].present?
    @published_items = @published_items.where("LOWER(urls.url_desc) ~ ?", params[:url_desc].downcase) if params[:url_desc].present?
    @published_items = @published_items.where(publishable_type: params[:publishable_type]) if params[:publishable_type].present?
    @published_items = @published_items.where(locations: { id: params[:location_id] }) if params[:location_id].present?
    @published_items = @published_items.where(place_categories: { id: params[:place_category_id] }) if params[:place_category_id].present?
    @published_items = @published_items.where(story_categories: { id: params[:story_category_id] }) if params[:story_category_id].present?
    @published_items = @published_items.where('published_items.created_at BETWEEN ? AND ?', params[:completed_at].to_date.beginning_of_day, params[:completed_at].to_date.end_of_day) if params[:completed_at].present?
    @published_items = @published_items.where(state: params[:state]) if params[:state].present?
    @published_items = @published_items.distinct

    if params[:order_by].present?
      col = params[:order_by].split(' ').first
      dir = params[:order_by].split(' ').last

      if col == 'completed_at'
        @published_items = @published_items.order('completed_at' => dir)
      else
        @published_items = @published_items.order(col => dir)
      end
    else
      @published_items = @published_items.order('state_order ASC', posted_at: :desc, completed_at: :desc)
    end

    @pagy, @published_items = pagy(@published_items)
  end

  def bulk_update
    @published_items = PublishedItem.where(id: bulk_update_params[:ids])

    if @published_items.present?
      begin
        case bulk_update_params[:update_type]
        when 'add_to_queue'
          @published_items.each{|item| item.queue! }
          action_text = 'added to the queue'
        when 'remove_from_public'
          @published_items.each{|item| item.publishable.remove! }
          action_text = 'removed from the public'
        when 'remove_from_queue'
          @published_items.each{|item| item.remove! }
          action_text = 'removed from the queue'
        when 'clear_from_newsfeed'
          @published_items.each{|item| item.clear! }
          action_text = 'removed from the newsfeed'
        end

        redirect_to admin_published_items_path, notice: "#{@published_items.size} items #{action_text}."
      rescue => e
        redirect_to admin_published_items_path, alert: e
      end
    else
      redirect_to admin_published_items_path, alert: "No selection was made."
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
