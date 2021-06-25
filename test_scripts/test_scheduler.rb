# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

stories_per_day = Code.where("code_key = 'STORIES_PER_DAY'").pluck('code_value')[0].to_i
puts "stories_per_day ---> #{stories_per_day}"

stories_every_x_secs = 60 * 60 * 24 / stories_per_day
puts "stories_every_x_secs ---> #{stories_every_x_secs}"

last_story_published_at = Story.order('sap_publish_date DESC').where.not(sap_publish_date: nil).pick('sap_publish_date')
last_story_published_at ||= '01/01/2014'.to_datetime
puts "last_story_published_at ---> #{last_story_published_at}"

next_story_to_publish = Story.order('created_at').where(sap_publish_date: nil).pick('id')
puts "next_story_to_publish ---> #{next_story_to_publish}"

next_story_pub_datetime_str = Code.where("code_key = 'NEXT_STORY_PUB_DATETIME'").pick('id', 'code_value')
puts "next_story_pub_datetime_str ---> #{next_story_pub_datetime_str[1]}"

next_story_pub_datetime = next_story_pub_datetime_str[1].to_datetime
# next_story_pub_datetime = next_story_pub_datetime_str[1].to_datetime.in_time_zone("Pacific Time (US & Canada)")
puts "next_story_pub_datetime ---> #{next_story_pub_datetime.in_time_zone('Pacific Time (US & Canada)')}"

time_left_before_pub = (next_story_pub_datetime.to_time - Time.zone.now).round
puts "time_left_before_pub ---> #{time_left_before_pub.round} secs"

if next_story_to_publish.nil?
  puts 'No stories available to publish'
elsif time_left_before_pub <= 0
  Story.find(next_story_to_publish).update(sap_publish_date: Time.zone.now)
  Code.find(next_story_pub_datetime_str[0]).update(code_value: (Time.zone.now + stories_every_x_secs).to_datetime.strftime('%Y-%m-%dT%H:%M:%S%z'))
  puts "publishing story ---> #{next_story_to_publish}"
  puts "updating code table 'NEXT_STORY_TO_PUBLISH' using code id ---> #{next_story_to_publish} with #{Time.zone.now + stories_every_x_secs}"
# puts "redirecting to root to refresh landing page"
# redirect_to "/"
else
  puts "too soon to publish; #{time_left_before_pub} secs remaining"
end
