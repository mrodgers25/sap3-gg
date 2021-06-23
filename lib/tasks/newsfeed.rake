namespace :newsfeed do
  desc 'Posts the next item in the queue to the newsfeed. It also clears out the newsfeed of old stories.'
  task post_item_from_queue: :environment do
    # Get the hourly publish rate
    hourly_post_rate = 24.0 / AdminSetting.newsfeed_daily_post_count
    # Get most recent posted_at timestamp
    last_posted_at = PublishedItem.where(state: 'newsfeed').maximum(:posted_at)

    if last_posted_at.blank?
      # if no items are posted post something.
      should_post_next_item = true
    else
      # convert the difference to hours
      hours_since_last_post = (Time.zone.now.utc.to_time - last_posted_at.utc.to_time) / 3600
      # if it's been longer than the limit then post
      should_post_next_item = hours_since_last_post >= hourly_post_rate
    end

    if should_post_next_item
      # Get the story next in the queue
      queued_item = PublishedItem.where(state: 'queued').order(:queue_position, :queued_at).first
      # Post the story
      queued_item.post! if queued_item

      # Get items that are set to be cleared by admin
      items_to_clear = PublishedItem.where(state: 'newsfeed').where('clear_at < ?', Time.zone.now)
      items_to_clear.each { |item| item.clear! }

      # Retrieve the remaining items and remove those above the limit
      newsfeed_items = PublishedItem.where(state: 'newsfeed').order(pinned: :desc, posted_at: :desc)
      if newsfeed_items.size > AdminSetting.newsfeed_display_limit
        amount_to_remove = newsfeed_items.size - AdminSetting.newsfeed_display_limit
        items_to_clear = newsfeed_items.last(amount_to_remove)
        items_to_clear.each { |item| item.clear! }
      end
    end
  end
end
