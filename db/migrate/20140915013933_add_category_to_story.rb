class AddCategoryToStory < ActiveRecord::Migration[6.0]
  def change
    add_column :stories, :cateogry_code, :text
  end
end
