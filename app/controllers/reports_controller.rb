class ReportsController < ApplicationController

  def csv_export_stories_users
    authorize Report

    require 'csv'
    require 'sendgrid-ruby'

    logged_in_user_email = User.find(current_user).email
    puts "User is #{logged_in_user_email}"

    # story export
    file = Rails.root.join('tmp','story_listing.csv')
    puts "File will be #{file}"

    stories = Story.includes(:urls => [:images])

    CSV.open( file, 'w' ) do |writer|
      writer << ["Id", "Created","SAP Publish","Story Type","YY","MM","DD","Tagline","Location","Place Category","Story Category","Author Trk", \
            "Story Yr Trk","Story Mnth Trk","Story Dt Trk","DataEntry Secs","URL","Domain","Manual"]
      stories.each do |s|
        s.urls.each do |u|
          u.images.each do |i|
            writer << [s.id, s.created_at, s.sap_publish_date, s.story_type, s.story_year, s.story_month, s.story_date, s.editor_tagline, \
                  s.location_code, s.place_category, s.story_category, s.author_track, s.story_year_track, \
                  s.story_month_track, s.story_date_track, s.data_entry_time, u.url_full, u.url_domain, i.manual_enter]
          end
        end
      end
    end

    # user export
    file2 = Rails.root.join('tmp','user_listing.csv')
    puts "File will be #{file2}"

    users = User.all

    CSV.open( file2, 'w' ) do |writer|
      writer << ["email","reset_password_sent_at","remember_created_at","sign_in_count","current_sign_in_at","last_sign_in_at", \
      "current_sign_in_ip","last_sign_in_ip","created_at","updated_at","name","role","confirmation_token","confirmed_at", \
      "confirmation_sent_at","unconfirmed_email","first_name","last_name","city_preference"]
      
      users.each do |u|
            writer << [u.email,u.reset_password_sent_at,u.remember_created_at,u.sign_in_count,u.current_sign_in_at,u.last_sign_in_at, \
      u.current_sign_in_ip,u.last_sign_in_ip,u.created_at,u.updated_at,u.name,u.role,u.confirmation_token,u.confirmed_at, \
      u.confirmation_sent_at,u.unconfirmed_email,u.first_name,u.last_name,u.city_preference]
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
    mail.add_attachment("#{file2}")
    puts client.send(mail)

    redirect_to :back, notice: "Export sent to #{logged_in_user_email}"

end

  def csv_export_stories
    authorize Report

    require 'csv'
    require 'sendgrid-ruby'

    logged_in_user_email = User.find(current_user).email
    puts "User is #{logged_in_user_email}"

    # story export
    file = Rails.root.join('tmp','story_listing.csv')
    puts "File will be #{file}"

    stories = Story.includes(:urls => [:images])

    CSV.open( file, 'w' ) do |writer|
      writer << ["Id", "Created","SAP Publish","Story Type","YY","MM","DD","Tagline","Location","Place Category","Story Category","Author Trk", \
            "Story Yr Trk","Story Mnth Trk","Story Dt Trk","DataEntry Secs","URL","Domain","Manual"]
      stories.each do |s|
        s.urls.each do |u|
          u.images.each do |i|
            writer << [s.id, s.created_at, s.sap_publish_date, s.story_type, s.story_year, s.story_month, s.story_date, s.editor_tagline, \
                  s.location_code, s.place_category, s.story_category, s.author_track, s.story_year_track, \
                  s.story_month_track, s.story_date_track, s.data_entry_time, u.url_full, u.url_domain, i.manual_enter]
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

    redirect_to :back, notice: "Export sent to #{logged_in_user_email}"

end

end
