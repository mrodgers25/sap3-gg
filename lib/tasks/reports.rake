namespace :reports do
  desc "dump csv listing for story/urls/images for analysis"
  task csv_dump: :environment do
    require 'csv'

    # file = File.expand_path('#{RAILS_ROOT}/tmp/story_listing.csv')

    file = Rails.root.join('tmp','story_listing.csv')

    stories = Story.includes(:urls => [:images])

    CSV.open( file, 'w' ) do |writer|
      writer << ["Id", "Created","SAP Publish","YY","MM","DD","Tagline","Location","Place Category","Story Category","Author Trk", \
            "Story Yr Trk","Story Mnth Trk","Story Dt Trk","URL"]
      stories.each do |s|
        s.urls.each do |u|
          writer << [s.id, s.created_at, s.sap_publish_date, s.story_year, s.story_month, s.story_year, s.editor_tagline, \
                s.location_code, s.place_category, s.story_category, s.author_track, s.story_year_track, \
                s.story_month_track, s.story_date_track, u.url_full]
        end
      end
    end
    puts "Wrote csv file to #{file}"

  end

  desc "TODO"
  task my_task2: :environment do
  end

end
