namespace :update_permalink do
  desc "TODO"
  task update: :environment do
    #This script is used to update the permalink field in all stories
    all_stories = Story.all
    all_stories.each do |p|
      url_title = p.urls.first.url_title.parameterize.to_s
      short_title = url_title.truncate(55, separator: '-', omission: '')
      rand_hex = SecureRandom.hex(2)
      permalink = "#{rand_hex}/#{short_title}"
      puts "THIS IS THE PERMALINK #{permalink}"
      p.update_attribute(:permalink, "#{permalink}")
    end
  end
end
