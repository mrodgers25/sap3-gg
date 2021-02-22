class Admin::PublishedItemsController < Admin::BaseAdminController
  before_action :set_published_item, except: :index

  def index
    @published_items = PublishedItem.includes(publishable: [:locations, :story_activities])

    case params[:display_type]
    when 'published'
      @published_items = @published_items.where('publish_at <= ?', DateTime.now)
    when 'waiting'
      @published_items = @published_items.where('publish_at > ?', DateTime.now)
    when 'retiring'
      @published_items = @published_items.where.not(retire_at: nil)
    end

    @published_items = @published_items.order(position: :asc, created_at: :desc)

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
    params.require(:published_item).permit(:position, :publish_at, :retire_at, :pinned)
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
end
