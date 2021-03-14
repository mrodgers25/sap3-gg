class CreateVideoStoryLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :video_story_locations do |t|
      t.integer :video_story_id, null: false
      t.integer :location_id, null: false
      t.timestamps
    end
    add_index :video_story_locations, [:video_story_id, :location_id], unique: true
  end
end
