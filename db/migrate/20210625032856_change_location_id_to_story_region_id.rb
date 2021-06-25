class ChangeLocationIdToStoryRegionId < ActiveRecord::Migration[6.1]
  def change
    rename_table :story_locations, :stories_story_regions
    rename_column :stories_story_regions, :location_id, :story_region_id
  end
end
