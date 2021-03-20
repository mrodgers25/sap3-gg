namespace :scripts do
  desc "Converts the stories to the correct state"
  task convert_stories_to_correct_state: :environment do
    Story.find_each.each do |story|
      if story.draft? && story.story_complete && story.sap_publish_date && (story.sap_publish_date < DateTime.now)
        story.approve!
        story.publish!
      end
    end
  end

  desc "Checker for stories that need to be unpublished"
  task unpublish_past_stories: :environment do
    published_items = PublishedItem.where('unpublish_at <= ?', DateTime.now)
    published_items.each do |published_item|
      published_item.publishable.remove!
    end
  end

  desc "Moves published items in queued to displaying"
  task move_published_items_to_displaying: :environment do
    published_items = PublishedItem.where(state: 'queued').order(queue_position: :asc, created_at: :asc)
    published_items = published_items.limit(PublishedItem.publish_rate)

    published_items.each do |published_item|
      published_item.post!
    end
  end
end
