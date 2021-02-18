class RenameCatFieldInStories < ActiveRecord::Migration[6.0]
  def change
    rename_column :stories, :category_code, :place_code
  end
end
