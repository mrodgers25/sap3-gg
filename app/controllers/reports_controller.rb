class ReportsController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized

  include SendGrid

  def export_all
    authorize Report

    require 'csv'
    require 'sendgrid-ruby'
    require 'base64'

#byebug

    logged_in_user_email = current_user.email #User.find(current_user).email
    puts "******Email is #{logged_in_user_email}*****"

    # story export
    file_s = Rails.root.join('tmp','story_listing.csv')
    # puts "Story file will be #{file_s}"

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

    #CSV.open( file_u, 'w' ) do |writer|
    #  writer << ["id","first_name","last_name","role","email","city_preference","created_at","confirmation_sent_at", \
    #  "confirmed_at","reset_password_sent_at","remember_created_at", \
    #  "unconfirmed_email","updated_at","sign_in_count"]
#
   #   users.each do |u|
   #    writer << [u.id,u.first_name,u.last_name,u.role,u.email,u.city_preference,u.created_at,u.confirmation_sent_at, \
   #     u.confirmed_at,u.reset_password_sent_at,u.remember_created_at, \
   #     u.unconfirmed_email,u.updated_at,u.sign_in_count]
   #   end
   # end

    # action export
    file_a = Rails.root.join('tmp','action_listing.csv')
    # puts "Action file will be #{file_a}"
    file_o = Rails.root.join('tmp','outbound_click_listing.csv')
    # puts "Outbound clicks file will be #{file_o}"

    actions = User.includes(:events).joins(:events).order("ahoy_events.time")

    #CSV.open( file_a, 'w' ) do |writer|
    #  writer << ["Id","First","Last","Email","Date-Time","Controller","Controller-Action","Location","Place Category","Story Category","Button"]
    #  actions.each do |a|
    #    a.events.each do |e|
    #      if e.properties.values[5].present?  # filter actions
    #        writer << [a.id, a.first_name, a.last_name, a.email, e.time, e.properties.values[6], e.properties.values[7], \
    #              e.properties.values[2], e.properties.values[3], e.properties.values[4], e.properties.values[5]]
    #      end
    #      unless e.properties.values[5].present?  # non-filter actions
    #        writer << [a.id, a.first_name, a.last_name, a.email, e.time, e.properties.values[0], e.properties.values[1]]
     #     end
     #   end
    #  end
    #end

    #outbound_clicks = OutboundClick.all
    ##Outbound Reports
    #CSV.open( file_o, 'w' ) do |writer|
    #  writer << ["Id","UserId","Url","Created"]
    #  outbound_clicks.each do |c|
    #    writer << [c.id, c.user_id, c.url, c.created_at]
    #  end
    #end

     puts "sendgrid user is: #{ENV["SENDGRID_USERNAME"]}"
     puts "sendgrid password is: #{ENV["SENDGRID_PASSWORD"]}"

    #client = SendGrid::Client.new(api_user: ENV["SENDGRID_USERNAME"], api_key: ENV["SENDGRID_PASSWORD"])
    #client = SendGrid::Client.new(api_user: ENV["SENDGRID_USERNAME"], api_key: ENV["SENDGRID_API"])

client = SendGrid::API.new(api_key: ENV['SENDGRID_API'])

#response = sg.client.mail._('send').post(request_body: mail.to_json)
#NEXT SECTION IS A TEST
#from = Email.new(email: 'mrodgers@storiesaboutplaces.com')
#to = Email.new(email: 'mrodgers25@gmail.com')
#subject = 'Sending with SendGrid is Fun'
#content = Content.new(type: 'text/plain', value: 'and easy to do anywhere, even with Ruby')
#mail = Mail.new('StoriesAboutPlaces.com', 'TEST', '#{logged_in_user_email}', 'Your latest export files are attached.')

## Example that works - excpet attachments ###
#sg = SendGrid::API.new(api_key: ENV['SENDGRID_API'])
# my_file = File.read(file_s)
# my_file_encoded = Base64.encode64(my_file)
#
#data = JSON.parse('{
#  "personalizations": [
#    {
#      "to": [
#        {
#          "email": "mrodgers25@gmail.com"
#        }
#      ],
#      "subject": "Hello World from the SendGrid Ruby Library!"
#    }
#  ],
#  "from": {
#    "email": "mrodgers@storiesaboutplaces.com"
#  },
#  "content": [
#    {
#      "type": "text/plain",
#      "value": "Hello, Email!"
#    }
#  ],
#  "attachments": ['story_listing.csv']= { :data=> ActiveSupport::Base64.encode64(my_file), :encoding => 'base64' }
#  }')
## OR
 #{}"attachments": [
  #  {
  #    "content": #{my_file_encoded},
  #    "content_id": "ii_139db99fdb5c3704",
  #    "disposition": "inline",
  #    "filename": "story_listing.csv",
  #    "name": "story_listing",
  #    "type": "csv"
  #  }
  #]
#response = sg.client.mail._("send").post(request_body: data)
#puts response.status_code
#puts response.body
#puts response.headers
## END EXAMPLE THAT WORKS###

## PUT THIS ASIDE AND TRY JSON VERSION NOW ##
###Test email send with simple example -- THIS WORKS!###
#  from = Email.new(email: 'mrodgers@storiesaboutplaces.com')
#  to = Email.new(email: 'mrodgers25@gmail.com')
#  subject = 'Export of all Stories, Users and Actions'
#  content = Content.new(type: 'text/plain', value: 'Your latest export files are attached.')
#  mail = SendGrid::Mail.new(from, subject, to, content)
#
#  my_file = File.read(file_s)
#  my_file_encoded = Base64.encode64(my_file)
#
#  attachment = Attachment.new
#  attachment.content = my_file_encoded #'BwdW'
#  attachment.type = 'text/csv'  #'image/png'
#  attachment.filename = 'story_listing.csv'  #'banner.png'
#  attachment.disposition = 'inline'
#  attachment.content_id = 'Report'  #Banner'
#  mail.attachments = attachment
#  puts mail.to_json
  #

#  sg = SendGrid::API.new(api_key: ENV['SENDGRID_API'], host: 'https://api.sendgrid.com')
#  response = sg.client.mail._('send').post(request_body: mail.to_json)
#  puts response.status_code
#  puts response.body
#  puts response.headers
### END of email send with simple example ###
########

#THIS IS THE ORIGINAL CODE
    mail = SendGrid::Mail.new do |m|
      m.to = "#{logged_in_user_email}"
      m.from = 'StoriesAboutPlaces.com'
      m.subject = 'Export of all Stories, Users and Actions'
      m.text = 'Your latest export files are attached.'
    end
## END OF ORIGINAL CODE

## TEST ADDING ATTACHMENT ##
 # attachment = Attachment.new
 # attachment.content = '#{file_s}' #'BwdW'
 # attachment.type = 'text/plain'  #'image/png'
 # attachment.filename = '#{file_s}'  #'banner.png'
 # attachment.disposition = 'inline'
 # attachment.content_id = 'Report'  #Banner'
 # mail.attachments = attachment
 # puts mail.to_json

## END TEST ADD ATTACHMENT ##

    mail.addattachment("#{file_s}")
    #mail.add_attachment("#{file_u}")
    #mail.add_attachment("#{file_a}")
    #mail.add_attachment("#{file_o}")

##Part of original code
    puts client.send(mail)


    redirect_to :back, notice: "Exports created and sent. They should arrive in about 10 minutes at #{logged_in_user_email}"

  end

end
