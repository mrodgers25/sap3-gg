class ReportsController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized

  def export_all
    authorize Report

    require 'csv'
    require 'sendgrid-ruby'

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

#client = SendGrid::API.new(api_key: ENV['SENDGRID_PASSWORD'])

#response = sg.client.mail._('send').post(request_body: mail.to_json)
#NEXT SECTION IS A TEST
#from = Email.new(email: 'mrodgers@storiesaboutplaces.com')
#to = Email.new(email: 'mrodgers25@gmail.com')
#subject = 'Sending with SendGrid is Fun'
#content = Content.new(type: 'text/plain', value: 'and easy to do anywhere, even with Ruby')
#mail = Mail.new('StoriesAboutPlaces.com', 'TEST', '#{logged_in_user_email}', 'Your latest export files are attached.')

## Example that works ###
#sg = SendGrid::API.new(api_key: ENV['SENDGRID_PASSWORD'])
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
#  "attachments": [
#    {
#      "type": "text/plain",
#      "filename": "#{file_s}"
#    }
#  ]
#}')
#response = sg.client.mail._("send").post(request_body: data)
#puts response.status_code
#puts response.body
#puts response.headers
## END EXAMPLE THAT WORKS###

###Test email send with simple example###
from = Email.new(email: 'mrodgers@storiesaboutplaces.com')
to = Email.new(email: 'mrodgers25@gmail.com')
subject = 'Sending with SendGrid is Fun'
content = Content.new(type: 'text/plain', value: 'and easy to do anywhere, even with Ruby')
#mail = Mail.new('StoriesAboutPlaces.com', 'TEST', '#{logged_in_user_email}', 'Your latest export files are attached.')
  mail = Mail.new(from, subject, to, content)
  # puts JSON.pretty_generate(mail.to_json)
  puts mail.to_json

  sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'], host: 'https://api.sendgrid.com')
  response = sg.client.mail._('send').post(request_body: mail.to_json)
  puts response.status_code
  puts response.body
  puts response.headers


### END of email send with simple example ###



    #mail = SendGrid::Mail.new do |m|
    #  m.to = 'mrodgers25@gmail.com'
    #  m.from = 'mrodgers@StoriesAboutPlaces.com'
    #  m.subject = 'Export of all Stories, Users and Actions'
    #  m.txt = 'Your latest export files are attached.'
    #end

    #mail.add_attachment("#{file_s}")
    #mail.add_attachment("#{file_u}")
    #mail.add_attachment("#{file_a}")
    #mail.add_attachment("#{file_o}")

    #puts client.send(mail)
    #client.send(mail)

    redirect_to :back, notice: "Exports created and sent. They should arrive in about 10 minutes at #{logged_in_user_email}"

  end

end
