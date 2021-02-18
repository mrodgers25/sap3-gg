class AddLocationcdToStories < ActiveRecord::Migration[6.0]
  def change
    add_column :stories, :location_code, :text
  end
end
