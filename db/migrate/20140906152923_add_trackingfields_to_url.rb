class AddTrackingfieldsToUrl < ActiveRecord::Migration
  def change
    add_column :urls, :url_title_track, :boolean
    add_column :urls, :url_desc_track, :boolean
    add_column :urls, :url_keywords_track, :boolean
  end
end
