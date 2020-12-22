class RemoveDropdownsFromStories < ActiveRecord::Migration[6.0]
  def change
    remove_column :stories, :location_code, :text
    remove_column :stories, :place_category, :string
    remove_column :stories, :story_category, :string
  end
end
