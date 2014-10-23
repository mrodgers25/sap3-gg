namespace :reports do
  desc "dump csv listing for story/urls/images for analysis"
  task csv_dump: :environment do
    require 'csv'
    require 'sendgrid-ruby'

    file = Rails.root.join('tmp','story_listing.csv')
    puts "File will be #{file}"

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

    client = SendGrid::Client.new(api_user: ENV["SENDGRID_USERNAME"], api_key: ENV["SENDGRID_PASSWORD"])

    mail = SendGrid::Mail.new do |m|
      m.to = 'ggehrich@gmail.com'
      m.from = 'StoriesAboutPlaces.com'
      m.subject = 'CSV Export'
      m.text = 'Your latest export is attached.'
    end

    mail.add_attachment("#{file}")

    puts client.send(mail)

    puts "Wrote csv file to #{file}"
  end

  desc "TODO"
  task my_task2: :environment do
  end

end
