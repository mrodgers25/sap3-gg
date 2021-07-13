# frozen_string_literal: true

# Helpers for better embedding and manipulation of videos
# Place this code in app/helpers/videos_helper.rb
# Then from any view you can add:
#
#    <%= get_video_iframe('http://the.video.url') %>
#
# Optionally you can add width and height.
#
#    <%= get_video_iframe('http://the.video.url', '1600px', '900px') %>
#
# Thanks to https://stackoverflow.com/a/27878890/1498118

module VideosHelper
  require 'net/http'

  # Regex to find YouTube's and Vimeo's video ID
  YOUTUBE_REGEX = %r(^(https*://)?(www.)?(youtube.com|youtu.be)/(watch\?v=){0,1}([a-zA-Z0-9_-]{11})).freeze
  VIMEO_REGEX = %r{^https?://(?:.*?)\.?(vimeo)\.com/(\d+).*$}.freeze

  # Finds YouTube's video ID from given URL or [nil] if URL is invalid
  # The video ID matches the RegEx \[a-zA-Z0-9_-]{11}\
  def find_youtube_id(url)
    url = sanitize url
    matches = YOUTUBE_REGEX.match url.to_str
    matches[6] || matches[5] if matches
  end

  # Get YouTube video iframe from given URL
  def get_youtube_iframe(url, width, height)
    youtube_id = find_youtube_id url

    result = %(<iframe title="YouTube video player" width="#{width}"
                height="#{height}" src="//www.youtube.com/embed/#{youtube_id}"
                frameborder="0" allowfullscreen></iframe>)
    result.html_safe
  end

  # Finds Vimeo's video ID from given URL or [nil] if URL is invalid
  def find_vimeo_id(url)
    url = sanitize url
    matches = VIMEO_REGEX.match url.to_str
    matches[2] if matches
  end

  # Get Vimeo video iframe from given URL
  def get_vimeo_iframe(url, width, height)
    vimeo_id = find_vimeo_id url
    uri = "https://vimeo.com/api/oembed.json?url=https%3A//vimeo.com/#{vimeo_id}&width=#{width}&height=#{height}"
    # see -> https://stackoverflow.com/a/4581095/1498118
    response = Net::HTTP.get(URI.parse(uri))
    json = JSON.parse response
    json['html'].html_safe
  end

  # Main function
  # Return a video iframe
  # If the url provided is not a valid YouTube or Vimeo url it returns [nil]
  def get_video_iframe(url, width = '560px', height = '315px')
    return if url.blank?

    if find_vimeo_id(url)
      get_vimeo_iframe(url, width, height)
    elsif find_youtube_id(url)
      get_youtube_iframe(url, width, height)
    end
  end
end
