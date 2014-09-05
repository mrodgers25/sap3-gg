class AddLocationcdToStories < ActiveRecord::Migration
  def change
    add_column :stories, :location_code, :text
  end
end
