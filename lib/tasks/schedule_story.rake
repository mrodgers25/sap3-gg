namespace :schedule_story do
  desc "see if it's time to publish the next story"
  task check_pub_time: :environment do

    include Rails.application.routes.url_helpers
    9.times do
      stories_per_day = Code.where("code_key = 'STORIES_PER_DAY'").pluck("code_value")[0].to_i
      puts "stories_per_day ---> #{stories_per_day}"

      stories_every_x_secs = 60 * 60 * 24 / stories_per_day
      puts "stories_every_x_secs ---> #{stories_every_x_secs}"

      last_story_published_at = Story.order("sap_publish_date DESC").where("sap_publish_date is not null").pluck("sap_publish_date").first
      last_story_published_at ||= "01/01/2014".to_datetime
      puts "last_story_published_at ---> #{last_story_published_at}"

      # grab the oldest story by original publish date
      # next_story_to_publish = Story.order("story_year","story_month","story_date").where("sap_publish_date is null").pluck("id").first
      # grab the oldest story by original created date
      next_story_to_publish = Story.order("created_at").where("sap_publish_date is null").pluck("id").first
      puts "next_story_to_publish ---> #{next_story_to_publish}"

      if Code.where("code_key = 'NEXT_STORY_PUB_DATETIME'").present?
        next_story_pub_datetime_arr = Code.where("code_key = 'NEXT_STORY_PUB_DATETIME'").pluck("id","code_value").first
        puts "next_story_pub_datetime code_value ---> #{next_story_pub_datetime_arr[1]}"
      else
        puts "the code 'NEXT_STORY_PUB_DATETIME' is required for the story scheduler...exiting"
        exit
      end

      if next_story_pub_datetime_arr[1].present?
        next_story_pub_datetime = next_story_pub_datetime_arr[1].to_datetime
        puts "next_story_pub_datetime ---> #{next_story_pub_datetime.in_time_zone("Pacific Time (US & Canada)")}"

        time_left_before_pub = (next_story_pub_datetime.to_time - Time.now).round
        puts "time_left_before_pub ---> #{time_left_before_pub.round} secs"
      end

      unless next_story_to_publish.nil?
        if (time_left_before_pub ||= 0) <= 0
          Story.find(next_story_to_publish).update_attributes(sap_publish_date: Time.now)
          Code.find(next_story_pub_datetime_arr[0]).update_attributes(code_value: (Time.now + stories_every_x_secs).in_time_zone("Pacific Time (US & Canada)").strftime("%Y-%m-%dT%H:%M:%S%z"))
          puts "publishing story ---> #{next_story_to_publish}"
          puts "updating code table 'NEXT_STORY_TO_PUBLISH' using code id ---> #{next_story_to_publish} with #{(Time.now + stories_every_x_secs).in_time_zone("Pacific Time (US & Canada)").strftime("%Y-%m-%dT%H:%M:%S%z")}"
        else
          puts "too soon to publish; #{time_left_before_pub} secs remaining"
        end
      else
        puts "No stories available to publish"
      end
      sleep 60
    end
  end

  desc "TODO"
  task my_task2: :environment do
  end

end
