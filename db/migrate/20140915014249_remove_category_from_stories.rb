class RemoveCategoryFromStories < ActiveRecord::Migration
  def change
    remove_column :stories, :cateogry_code, :string
    add_column :stories, :category_code, :string
  end
end
