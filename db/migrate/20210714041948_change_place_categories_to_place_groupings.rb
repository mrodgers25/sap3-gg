class ChangePlaceCategoriesToPlaceGroupings < ActiveRecord::Migration[6.1]
  def change
    rename_table :place_groupings, :place_groupings

    rename_table :place_groupings_stories, :place_groupings_stories
    rename_column :place_groupings_stories, :place_grouping_id, :place_grouping_id
  end
end
