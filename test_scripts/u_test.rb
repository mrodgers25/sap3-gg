# frozen_string_literal: true

class ReportsController < ApplicationController
  require 'csv'

  file = 'story_listing.csv'
  puts "File will be #{file}"

  stories = Story.includes(urls: [:images])

  CSV.open(file, 'w') do |writer|
    writer << ['Id', 'Created', 'SAP Publish', 'Story Type', 'YY', 'MM', 'DD', 'Tagline', 'Location', 'Place Category', 'Story Category', 'Author Trk', \
               'Story Yr Trk', 'Story Mnth Trk', 'Story Dt Trk', 'URL', 'Domain', 'Manual']
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
end
