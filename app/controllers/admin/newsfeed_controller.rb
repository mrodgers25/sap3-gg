class Admin::NewsfeedController < Admin::BaseAdminController
  before_action :set_queued_item, except: [:index, :queue, :activities]

  def queue
    @queued_items = PublishedItem.joins("
      INNER JOIN stories ON (publishable_type = 'Story' AND stories.id = publishable_id)
      LEFT JOIN urls ON urls.story_id = stories.id
    ")
    @queued_items = @queued_items.where(state: 'queued')
    @queued_items = @queued_items.where("LOWER(urls.url_title) ~ ?", params[:url_title].downcase) if params[:url_title].present?

    if params[:order_by].present?
      col = params[:order_by].split(' ').first
      dir = params[:order_by].split(' ').last

      @queued_items = @queued_items.order(col => dir)
    else
      @queued_items = @queued_items.order(queue_position: :asc, queued_at: :asc)
    end

    @pagy, @queued_items = pagy(@queued_items)
  end

  def edit
  end

  def update
    if @queued_item.update(update_params)
      if @queued_item.queue_position != params[:old_queue_position].to_i
        set_queue_position
      end

      redirect_to queue_admin_newsfeed_index_path, notice: 'Queued Item was successfully updated.'
    else
      redirect_to queue_admin_newsfeed_index_path, alert: 'Queued Item failed to be updated.'
    end
  end

  def remove
    if @queued_item.remove!
      redirect_to queue_admin_newsfeed_index_path, notice: 'Queued Item was successfully removed.'
    else
      redirect_to queue_admin_newsfeed_index_path, alert: 'Queued Item failed to be removed.'
    end
  end

  def publish
     if @queued_item.post!
      redirect_to queue_admin_newsfeed_index_path, notice: 'Queued Item was successfully posted.'
    else
      redirect_to queue_admin_newsfeed_index_path, alert: 'Queued Item failed to be posted.'
    end
  end

  def activities
    @activities = NewsfeedActivity.joins("
      INNER JOIN stories ON (trackable_type = 'Story' AND stories.id = trackable_id)
      INNER JOIN urls ON urls.story_id = stories.id
    ")
    @activities = @activities.where("LOWER(urls.url_title) ~ ?", params[:url_title].downcase) if params[:url_title].present?
    @activities = @activities.where(activity_type: params[:activity_type]) if params[:activity_type].present?

    if params[:order_by].present?
      col = params[:order_by].split(' ').first
      dir = params[:order_by].split(' ').last

      @activities = @activities.order(col => dir)
    else
      @activities = @activities.order(id: :desc)
    end

    @pagy, @activities = pagy(@activities)
  end

  private

  def set_queued_item
    begin
      @queued_item = PublishedItem.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to queue_admin_newsfeed_index_path, alert: 'Queued Item not found.'
    end
  end

  def update_params
    params.require(:published_item).permit(:queue_position, :clear_at, :pinned, :pinned_action)
  end

  def set_queue_position
    published_item = PublishedItem.find(params[:id])
    new_position   = published_item.queue_position
    old_position   = params[:old_queue_position].to_i

    if new_position && old_position && (new_position <= old_position)
      PublishedItem.update(queue_position: (new_position - 1))
    end
    # resort all other positions
    PublishedItem.resequence_all_queue_positions
  end
end
