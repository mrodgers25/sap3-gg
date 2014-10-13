class RenameCatFieldInStories < ActiveRecord::Migration
  def change
    rename_column :stories, :category_code, :place_code
  end
end
