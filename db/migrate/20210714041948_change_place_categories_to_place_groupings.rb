class ChangePlaceCategoriesToPlaceGroupings < ActiveRecord::Migration[6.1]
  def change
    rename_table :place_categories, :place_groupings

    rename_table :story_place_categories, :place_groupings_stories
    rename_column :place_groupings_stories, :place_category_id, :place_grouping_id
  end
end
