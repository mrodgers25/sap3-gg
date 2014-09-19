class AddTrackingFieldsToStories < ActiveRecord::Migration
  def change
    add_column :stories, :author_track, :boolean
    add_column :stories, :story_year_track, :boolean
    add_column :stories, :story_month_track, :boolean
    add_column :stories, :story_date_track, :boolean
  end
end
