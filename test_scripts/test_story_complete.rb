# frozen_string_literal: true

require File.expand_path('../config/environment', __dir__)

def story_url_complete?(id)
  story_is_complete = Story.where("id = #{id}
      and (story_year is not null
          or story_month is not null
          or story_date is not null)
      and (location_code != ''
          or place_category != ''
          or story_category != '')
      and editor_tagline is not null").present?

  url_is_complete = Url.where("story_id = #{id}
      and url_type != ''
      and url_title  != ''
      and url_desc != ''
      and url_domain != '' ").present?

  story_url_is_complete = if story_is_complete && url_is_complete
                            true
                          else
                            false
                          end

  puts "id is #{id}"
  puts "story_is_complete is #{story_is_complete}"
  puts "url_is_complete is #{url_is_complete}"
  puts "story_url_is_complete is #{story_url_is_complete}"
end

story_url_complete?(32)
