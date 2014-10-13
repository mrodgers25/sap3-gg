class RenameCatField2InStories < ActiveRecord::Migration
  def change
    rename_column :stories, :place_code, :place_category
  end
end
