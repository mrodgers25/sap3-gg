namespace :update_permalink do
  desc "TODO"
  task update: :environment do
    #This script is used to update the permalink field in all stories
    all_stories = Story.all
    all_stories.each do |p|
      url_title = p.urls.first.url_title.parameterize
      rand_hex = SecureRandom.hex(2)
      permalink = "#{rand_hex}/#{url_title}"
      puts "THIS IS THE PERMALINK #{permalink} XOXOXOXO"
      p.update_attribute(:permalink, "#{permalink}")
    end
  end
end
