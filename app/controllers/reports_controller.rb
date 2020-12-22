class ReportsController < ApplicationController
  before_action :authenticate_user!
  #after_action :verify_authorized

  include SendGrid


  def index
    #authorize Report
    @users = User.all
    authorize User

  end

  def export_allstories
    #authorize Report

    @reports = Story.all

    respond_to do |format|
      format.html
      format.csv { send_data @reports.to_csv, filename: 'export_allstories.csv' }
    end
  end

  def export_stories

    stories = Story.eager_load(:urls => [:images]).eager_load(:locations).eager_load(:place_categories).eager_load(:story_categories).order(:id)

    output = CSV.generate do |writer|
      writer << ["Id", "Created","SAP Publish","Story Type","YY","MM","DD","Tagline","Location","Place Category","Story Category","Author Trk", \
            "Story Yr Trk","Story Mnth Trk","Story Dt Trk","DataEntry Secs","URL","Domain","Media Owner Id","Manual Img","Data Entered By","Story Complete"]
      stories.each do |s|
        @url_full,@url_domain,@manual_enter,@location_name,@pc_name,@sc_name = ["","","","","",""]
        s.urls.each do |u|
          @url_full = u.url_full
          @url_domain = u.url_domain
          u.images.each do |i|
            @manual_enter = i.manual_enter
          end
        end
        @location_name = s.locations.map { |l| l.code }.join(',')
        @pc_name = s.place_categories.map { |pc| pc.code }.join(',')
        @sc_name = s.story_categories.map { |sc| sc.code }.join(',')

        writer << [s.id, s.created_at, s.sap_publish_date, s.story_type, s.story_year, s.story_month, s.story_date, s.editor_tagline, \
                  @location_name, @pc_name, @sc_name, s.author_track, s.story_year_track, s.story_month_track, s.story_date_track, \
                  s.data_entry_time, @url_full, @url_domain, s.mediaowner_id, @manual_enter, s.data_entry_user, s.story_complete]
        end
      end

    respond_to do |format|
      format.html
      format.csv { send_data output, filename: 'export_stories.csv' }
    end
  end

  def export_images
    @images = Image.all

    respond_to do |format|
      format.html
      format.csv { send_data @images.to_csv, filename: 'export_images.csv' }
    end
  end

  def export_mediaowners
    @mediaowners = Mediaowner.all

    respond_to do |format|
      format.html
      format.csv { send_data @mediaowners.to_csv, filename: 'export_mediaowners.csv' }
    end
  end

  def export_usersaved
    @usersaved = Usersavedstory.all

    respond_to do |format|
      format.html
      format.csv { send_data @usersaved.to_csv, filename: 'export_usersavedstory.csv' }
    end
  end

  ##One of the origin reports ##
  def export_userlisting
  # user export
    users = User.order(:id)

    output = CSV.generate do |writer|
      writer << ["id","first_name","last_name","role","email","city_preference","created_at","confirmation_sent_at", \
      "confirmed_at","reset_password_sent_at","remember_created_at", \
      "unconfirmed_email","updated_at","sign_in_count"]

      users.each do |u|
       writer << [u.id,u.first_name,u.last_name,u.role,u.email,u.city_preference,u.created_at,u.confirmation_sent_at, \
        u.confirmed_at,u.reset_password_sent_at,u.remember_created_at, \
        u.unconfirmed_email,u.updated_at,u.sign_in_count]
      end
    end

    respond_to do |format|
      format.html
      format.csv { send_data output, filename: 'export_userlisting.csv' }
    end
  end

  def export_actionlisting
  #action export
    actions = User.includes(:events).joins(:events).order("ahoy_events.time")

    output = CSV.generate do |writer|
      writer << ["Id","First","Last","Email","Date-Time","Controller","Controller-Action","Location","Place Category","Story Category","Button"]
      actions.each do |a|
        a.events.each do |e|
          if e.properties.values[5].present?  # filter actions
            writer << [a.id, a.first_name, a.last_name, a.email, e.time, e.properties.values[6], e.properties.values[7], \
                  e.properties.values[2], e.properties.values[3], e.properties.values[4], e.properties.values[5]]
          end
          unless e.properties.values[5].present?  # non-filter actions
            writer << [a.id, a.first_name, a.last_name, a.email, e.time, e.properties.values[0], e.properties.values[1]]
          end
        end
      end
    end
    respond_to do |format|
      format.html
      format.csv { send_data output, filename: 'export_actionlisting.csv' }
    end
  end

  def export_outboundclick
    outbound_clicks = OutboundClick.all

    output = CSV.generate do |writer|
      writer << ["Id","UserId","Url","Created"]
      outbound_clicks.each do |c|
        writer << [c.id, c.user_id, c.url, c.created_at]
      end
    end
    respond_to do |format|
      format.html
      format.csv { send_data output, filename: 'export_outboundclick.csv' }
    end
  end


## Below here was the origin code -- this is for emailing -- does not work currently##
  def export_all
    authorize Report

    require 'csv'
    require 'sendgrid-ruby'
    require 'base64'

    logged_in_user_email = current_user.email #User.find(current_user).email
    puts "******Email is #{logged_in_user_email}*****"

    # story export
    file_s = Rails.root.join('tmp','story_listing.csv')
    puts "Story file will be #{file_s}"

    stories = Story.eager_load(:urls => [:images]).eager_load(:locations).eager_load(:place_categories).eager_load(:story_categories).order(:id)

    CSV.open( file_s, 'w' ) do |writer|
      writer << ["Id", "Created","SAP Publish","Story Type","YY","MM","DD","Tagline","Location","Place Category","Story Category","Author Trk", \
            "Story Yr Trk","Story Mnth Trk","Story Dt Trk","DataEntry Secs","URL","Domain","Media Owner Id","Manual Img","Data Entered By","Story Complete"]
      stories.each do |s|
        @url_full,@url_domain,@manual_enter,@location_name,@pc_name,@sc_name = ["","","","","",""]
        s.urls.each do |u|
          @url_full = u.url_full
          @url_domain = u.url_domain
          u.images.each do |i|
            @manual_enter = i.manual_enter
          end
        end
        @location_name = s.locations.map { |l| l.code }.join(',')
        @pc_name = s.place_categories.map { |pc| pc.code }.join(',')
        @sc_name = s.story_categories.map { |sc| sc.code }.join(',')

        writer << [s.id, s.created_at, s.sap_publish_date, s.story_type, s.story_year, s.story_month, s.story_date, s.editor_tagline, \
                  @location_name, @pc_name, @sc_name, s.author_track, s.story_year_track, s.story_month_track, s.story_date_track, \
                  s.data_entry_time, @url_full, @url_domain, s.mediaowner_id, @manual_enter, s.data_entry_user, s.story_complete]
      end
    end

    # user export
    file_u = Rails.root.join('tmp','user_listing.csv')
    # puts "User file will be #{file_u}"

    users = User.order(:id)

    CSV.open( file_u, 'w' ) do |writer|
      writer << ["id","first_name","last_name","role","email","city_preference","created_at","confirmation_sent_at", \
      "confirmed_at","reset_password_sent_at","remember_created_at", \
      "unconfirmed_email","updated_at","sign_in_count"]

      users.each do |u|
       writer << [u.id,u.first_name,u.last_name,u.role,u.email,u.city_preference,u.created_at,u.confirmation_sent_at, \
        u.confirmed_at,u.reset_password_sent_at,u.remember_created_at, \
        u.unconfirmed_email,u.updated_at,u.sign_in_count]
      end
    end

    # action export
    file_a = Rails.root.join('tmp','action_listing.csv')
    # puts "Action file will be #{file_a}"
    file_o = Rails.root.join('tmp','outbound_click_listing.csv')
    # puts "Outbound clicks file will be #{file_o}"

    actions = User.includes(:events).joins(:events).order("ahoy_events.time")

    CSV.open( file_a, 'w' ) do |writer|
      writer << ["Id","First","Last","Email","Date-Time","Controller","Controller-Action","Location","Place Category","Story Category","Button"]
      actions.each do |a|
        a.events.each do |e|
          if e.properties.values[5].present?  # filter actions
            writer << [a.id, a.first_name, a.last_name, a.email, e.time, e.properties.values[6], e.properties.values[7], \
                  e.properties.values[2], e.properties.values[3], e.properties.values[4], e.properties.values[5]]
          end
          unless e.properties.values[5].present?  # non-filter actions
            writer << [a.id, a.first_name, a.last_name, a.email, e.time, e.properties.values[0], e.properties.values[1]]
          end
        end
      end
    end

    outbound_clicks = OutboundClick.all
    ##Outbound Reports
    CSV.open( file_o, 'w' ) do |writer|
      writer << ["Id","UserId","Url","Created"]
      outbound_clicks.each do |c|
        writer << [c.id, c.user_id, c.url, c.created_at]
      end
    end

     puts "sendgrid user is: #{ENV["SENDGRID_USERNAME"]}"
     puts "sendgrid password is: #{ENV["SENDGRID_PASSWORD"]}"

    client = SendGrid::Client.new(api_user: ENV["SENDGRID_USERNAME"], api_key: ENV["SENDGRID_PASSWORD"])

    mail = SendGrid::Mail.new do |m|
      m.to = "#{logged_in_user_email}"
      m.from = 'StoriesAboutPlaces.com'
      m.subject = 'Export of all Stories, Users and Actions'
      m.text = 'Your latest export files are attached.'
    end

    mail.add_attachment("#{file_s}")
    mail.add_attachment('tmp','story_listing.csv')
    mail.add_attachment("#{file_u}")
    mail.add_attachment("#{file_a}")
    mail.add_attachment("#{file_o}")

##Part of original code
    puts client.send(mail)

    redirect_to :back, notice: "Exports created and sent. They should arrive in about 10 minutes at #{logged_in_user_email}"

  end

end
