class Admin::QueuedItemsController < Admin::BaseAdminController
  def index
    @locations        = Location.order("ascii(name)")
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)

    @queued_items = PublishedItem.joins("
      INNER JOIN stories ON (publishable_type = 'Story' AND stories.id = publishable_id)
      INNER JOIN urls ON urls.story_id = stories.id
      LEFT JOIN stories_users ON stories_users.story_id = stories.id
      LEFT JOIN story_locations ON story_locations.story_id = stories.id
      LEFT JOIN locations ON locations.id = story_locations.location_id
      LEFT JOIN story_place_categories ON story_place_categories.story_id = stories.id
      LEFT JOIN place_categories ON place_categories.id = story_place_categories.place_category_id
      LEFT JOIN story_story_categories ON story_story_categories.story_id = stories.id
      LEFT JOIN story_categories ON story_categories.id = story_story_categories.story_category_id
    ")
    @queued_items = @queued_items.where(state: 'queued')
    @queued_items = @queued_items.where("LOWER(urls.url_title) ~ ?", params[:url_title].downcase) if params[:url_title].present?
    @queued_items = @queued_items.where("LOWER(urls.url_desc) ~ ?", params[:url_desc].downcase) if params[:url_desc].present?
    @queued_items = @queued_items.where(publishable_type: params[:publishable_type]) if params[:publishable_type].present?
    @queued_items = @queued_items.where(locations: { id: params[:location_id] }) if params[:location_id].present?
    @queued_items = @queued_items.where(place_categories: { id: params[:place_category_id] }) if params[:place_category_id].present?
    @queued_items = @queued_items.where(story_categories: { id: params[:story_category_id] }) if params[:story_category_id].present?
    @queued_items = @queued_items.order(queue_position: :asc, created_at: :asc)

    if params[:order_by].present?
      col = params[:order_by].split(' ').first
      dir = params[:order_by].split(' ').last
      # sort by stories.created_at vs queued_items
      if col == 'created_at'
        @queued_items = @queued_items.order("stories.#{col}" => dir)
      else
        @queued_items = @queued_items.order(col => dir)
      end
    else
      @queued_items = @queued_items.order(position: :asc, created_at: :desc)
    end

    @pagy, @queued_items = pagy(@queued_items)
  end

  def edit
  end

  def update
    if @queued_item.update(update_params)
      if @queued_item.position != params[:old_position].to_i
        set_display_position
      end

      if @queued_item.queue_position != params[:old_position].to_i
        set_queue_position
      end

      redirect_to queue_admin_published_items_path, notice: 'Published Item was successfully updated.'
    else
      redirect_to queue_admin_published_items_path, alert: 'Published Item failed to be updated.'
    end
  end

  def add
    @locations        = Location.order("ascii(name)")
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)

    @queued_items = PublishedItem.joins("
      INNER JOIN stories ON (publishable_type = 'Story' AND stories.id = publishable_id)
      INNER JOIN urls ON urls.story_id = stories.id
      LEFT JOIN stories_users ON stories_users.story_id = stories.id
      LEFT JOIN story_locations ON story_locations.story_id = stories.id
      LEFT JOIN locations ON locations.id = story_locations.location_id
      LEFT JOIN story_place_categories ON story_place_categories.story_id = stories.id
      LEFT JOIN place_categories ON place_categories.id = story_place_categories.place_category_id
      LEFT JOIN story_story_categories ON story_story_categories.story_id = stories.id
      LEFT JOIN story_categories ON story_categories.id = story_story_categories.story_category_id
    ").select('published_items.*, stories.*, stories_users.created_at AS save_date')
    @queued_items = @queued_items.where(state: 'displaying')
    @queued_items = @queued_items.where("LOWER(urls.url_title) ~ ?", params[:url_title].downcase) if params[:url_title].present?
    @queued_items = @queued_items.where("LOWER(urls.url_desc) ~ ?", params[:url_desc].downcase) if params[:url_desc].present?
    @queued_items = @queued_items.where(publishable_type: params[:publishable_type]) if params[:publishable_type].present?
    @queued_items = @queued_items.where(locations: { id: params[:location_id] }) if params[:location_id].present?
    @queued_items = @queued_items.where(place_categories: { id: params[:place_category_id] }) if params[:place_category_id].present?
    @queued_items = @queued_items.where(story_categories: { id: params[:story_category_id] }) if params[:story_category_id].present?
    @queued_items = @queued_items.order(queue_position: :asc, created_at: :asc)

    if params[:order_by].present?
      col = params[:order_by].split(' ').first
      dir = params[:order_by].split(' ').last
      # sort by stories.created_at vs queued_items
      if col == 'created_at'
        @queued_items = @queued_items.order("stories.#{col}" => dir)
      else
        @queued_items = @queued_items.order(col => dir)
      end
    else
      @queued_items = @queued_items.order(position: :asc, created_at: :desc)
    end

    @queued_items = @queued_items.distinct

    @pagy, @queued_items = pagy(@queued_items)
  end

  def bulk_add
    @items_to_add = PublishedItem.where(id: bulk_add_params[:ids])

    if @items_to_add.present?
      @items_to_add.each{|item| item.queue! }

      redirect_to add_admin_queued_items_path, notice: "Added #{@items_to_add.size} items to the queue."
    else
      redirect_to add_admin_queued_items_path, alert: "No selection was made."
    end
  end

  private

  def update_params
    params.require(:published_item).permit(:queue_position, :position, :unpublish_at, :pinned)
  end

  def bulk_add_params
    params.permit(ids: [])
  end

  def set_display_position
    published_item = PublishedItem.find(params[:id])
    new_position   = published_item.position
    old_position   = params[:old_position].to_i

    if new_position && old_position && (new_position <= old_position)
      PublishedItem.update(position: (new_position - 1))
    end
    # resort all other positions
    sorted_by_position = PublishedItem.where.not(position: nil).order(position: :asc, updated_at: :desc)
    sorted_by_position.each_with_index do |published_item, index|
      position = index + 1
      published_item.update(position: position)
    end
  end

  def set_queue_position
    published_item = PublishedItem.find(params[:id])
    new_position   = published_item.queue_position
    old_position   = params[:old_queue_position].to_i

    if new_position && old_position && (new_position <= old_position)
      PublishedItem.update(queue_position: (new_position - 1))
    end
    # resort all other positions
    sorted_by_position = PublishedItem.where.not(queue_position: nil).order(queue_position: :asc, updated_at: :desc)
    sorted_by_position.each_with_index do |published_item, index|
      position = index + 1
      published_item.update(queue_position: position)
    end
  end
end
