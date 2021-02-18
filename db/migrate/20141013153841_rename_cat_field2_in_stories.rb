class RenameCatField2InStories < ActiveRecord::Migration[6.0]
  def change
    rename_column :stories, :place_code, :place_category
  end
end
