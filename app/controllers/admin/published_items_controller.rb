class Admin::PublishedItemsController < Admin::BaseAdminController
  before_action :set_published_item, except: :index

  def index
    # database dropdown data
    @locations        = Location.order("ascii(name)")
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)

    @published_items = PublishedItem.joins("INNER JOIN stories ON (publishable_type = 'Story' AND stories.id = publishable_id)")

    case params[:published_state]
    when 'displaying'
      @published_items = @published_items.where('publish_at <= ?', DateTime.now)
    when 'waiting_to_display'
      @published_items = @published_items.where('publish_at > ?', DateTime.now)
    when 'will_unpublish'
      @published_items = @published_items.where.not(unpublish_at: nil)
    end

    if params[:order_by].present?
      col = params[:order_by].split(' ').first
      dir = params[:order_by].split(' ').last
      # sort by stories.created_at vs published_items
      if col == 'created_at'
        @published_items = @published_items.order("stories.#{col}" => dir)
      else
        @published_items = @published_items.order(col => dir)
      end
    else
      @published_items = @published_items.order(position: :asc, created_at: :desc)
    end


    @pagy, @published_items = pagy(@published_items)
  end

  def edit
  end

  def update
    if @published_item.update(published_item_params)
      if @published_item.position != params[:old_position].to_i
        set_release_position
      end

      redirect_to admin_published_items_path, notice: 'Published Item was successfully updated.'
    else
      redirect_to admin_published_items_path, alert: 'Published Item failed to be updated.'
    end
  end

  def publish
    if @published_item.update(publish_at: DateTime.now)
      redirect_to admin_published_items_path, notice: 'Published Item was successfully published.'
    else
      redirect_to admin_published_items_path, alert: 'Published Item failed to be published.'
    end
  end

  def unpublish
    if @published_item.publishable.unpublish!
      redirect_to admin_published_items_path, notice: 'Published Item was successfully unpublished.'
    else
      redirect_to admin_published_items_path, alert: 'Published Item failed to be unpublished.'
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

  def published_item_params
    params.require(:published_item).permit(:position, :publish_at, :unpublish_at, :pinned)
  end

  def set_release_position
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

  # def set_release_position_v2
  #   # look at currently modified item
  #   current_item = PublishedItem.find(params[:id])
  #   # if it shares a position, sort by newest update first
  #   items_with_same_position = PublishedItem.where(position: current_item.position).order(updated_at: :desc)
  #   # only run this code if there are duplicate positions
  #   until items_with_same_position.size == 1
  #     older_item = items_with_same_position.last
  #     older_item.update(position: current_item.position + 1)
  #     items_with_same_position = PublishedItem.where(position: older_item.position).order(updated_at: :desc)
  #   end
  # end
end
