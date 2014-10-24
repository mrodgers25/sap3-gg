class ReportsController < ApplicationController

  def csv_export
    require 'csv'
    require 'sendgrid-ruby'

    file = Rails.root.join('tmp','story_listing.csv')
    puts "File will be #{file}"
    logged_in_user_email = User.find(current_user).email
    puts "User is #{logged_in_user_email}"

    stories = Story.includes(:urls => [:images])

    CSV.open( file, 'w' ) do |writer|
      writer << ["Id", "Created","SAP Publish","Story Type","YY","MM","DD","Tagline","Location","Place Category","Story Category","Author Trk", \
            "Story Yr Trk","Story Mnth Trk","Story Dt Trk","URL","Domain","Manual"]
      stories.each do |s|
        s.urls.each do |u|
          u.images.each do |i|
            writer << [s.id, s.created_at, s.sap_publish_date, s.story_type, s.story_year, s.story_month, s.story_date, s.editor_tagline, \
                  s.location_code, s.place_category, s.story_category, s.author_track, s.story_year_track, \
                  s.story_month_track, s.story_date_track, u.url_full, u.url_domain, i.manual_enter]
          end
        end
      end
    end

    client = SendGrid::Client.new(api_user: ENV["SENDGRID_USERNAME"], api_key: ENV["SENDGRID_PASSWORD"])

    mail = SendGrid::Mail.new do |m|
      m.to = "#{logged_in_user_email}"
      m.from = 'StoriesAboutPlaces.com'
      m.subject = 'CSV Export'
      m.text = 'Your latest export is attached.'
    end

    mail.add_attachment("#{file}")
    puts client.send(mail)

    # redirect_to '/'

    redirect_to :back, notice: "Export sent to #{logged_in_user_email}"

end

end
