class AddCategoryToStory < ActiveRecord::Migration
  def change
    add_column :stories, :cateogry_code, :text
  end
end
