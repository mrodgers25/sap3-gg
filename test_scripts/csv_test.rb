require File.expand_path('../../config/environment', __FILE__)

require 'csv'
 
file = File.expand_path('~/Downloads/story_listing.csv')
 
# stories = Story.all
stories = Story.eager_load(:urls => [:images]).eager_load(:locations).eager_load(:place_categories).eager_load(:story_categories).order(:id)

CSV.open( file, 'w' ) do |writer|
  writer << ["Id", "Created","SAP Publish","Story Type","YY","MM","DD","Tagline","Location","Place Category","Story Category","Author Trk", \
            "Story Yr Trk","Data Entered By","Media Owner Id","Story Complete","Story Mnth Trk","Story Dt Trk","DataEntry Secs","URL","Domain","Manual"]
  stories.each do |s|
    s.urls.each do |u|
      @url_full = u.url_full
      @url_domain = u.url_domain
      u.images.each do |i|
        @manual_enter = i.manual_enter
      end
    end
    s.locations.each do |l|
      @location_name = l.name
    end
    s.place_categories.each do |pc|
      @pc_name = pc.name
    end
    s.story_categories.each do |sc|
      @sc_name = sc.name
    end
    writer << [s.id, s.created_at, s.sap_publish_date, s.story_type, s.story_year, s.story_month, s.story_date, s.editor_tagline, \
                  @location_name, @pc_name, @sc_name, s.author_track, s.story_year_track, s.data_entry_user, s.mediaowner_id, \
                  s.story_complete, \
                  s.story_month_track, s.story_date_track, s.data_entry_time, @url_full, @url_domain, @manual_enter]
  end
end

#
# CSV.open( file, 'w' ) do |writer|
#   writer << ["Id", "Created","SAP Publish","YY","MM","DD","Tagline","Location","Place Category","Story Category","Author Trk", \
#             "Story Yr Trk","Story Mnth Trk","Story Dt Trk","URL"]
#   stories.each do |s|
#     s.urls.each do |u|
#       @turl_full = u.url_full
#     s.locations.each do |l|
#       loc_name = l.name
#     end
#     end
#     writer << [s.id, s.created_at, s.sap_publish_date, s.story_year, s.story_month, s.story_year, s.editor_tagline, \
#                 @turl_full, s.author_track, s.story_year_track, \
#                 s.story_month_track, s.story_date_track]
#   end
# end
