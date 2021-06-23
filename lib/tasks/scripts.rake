namespace :scripts do
  desc 'Converts the stories to the correct state'
  task convert_stories_to_correct_state: :environment do
    Story.find_each.each do |story|
      if story.draft? && story.story_complete && story.sap_publish_date && (story.sap_publish_date < DateTime.now)
        story.approve!
        story.publish!
      end
    end
  end
end
