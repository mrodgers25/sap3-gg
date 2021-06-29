class RenameLocationsToStoryRegions < ActiveRecord::Migration[6.1]
  def change
    rename_table :locations, :story_regions
  end
end
