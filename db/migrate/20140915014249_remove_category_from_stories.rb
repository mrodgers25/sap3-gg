class RemoveCategoryFromStories < ActiveRecord::Migration[6.0]
  def change
    remove_column :stories, :cateogry_code, :string
    add_column :stories, :category_code, :string
  end
end
