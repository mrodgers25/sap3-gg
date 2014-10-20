require 'csv'
 
file = File.expand_path('~/Downloads/story_listing.csv')
 
# stories = Story.all
stories = Story.includes(:urls => [:images])

CSV.open( file, 'w' ) do |writer|
  writer << ["Id", "Created","SAP Publish","YY","MM","DD","Tagline","Location","Place Category","Story Category","Author Trk", \
            "Story Yr Trk","Story Mnth Trk","Story Dt Trk","URL"]
  stories.each do |s|
    s.urls.each do |u|
      writer << [s.id, s.created_at, s.sap_publish_date, s.story_year, s.story_month, s.story_year, s.editor_tagline, \
                s.location_code, s.place_category, s.story_category, s.author_track, s.story_year_track, \
                s.story_month_track, s.story_date_track, u.url_full]
    end
  end
end
