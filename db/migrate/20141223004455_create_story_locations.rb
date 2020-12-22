class CreateStoryLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :story_locations do |t|
      t.integer :story_id, null: false
      t.integer :location_id, null: false
      t.timestamps
    end
    add_index :story_locations, [:story_id, :location_id], unique: true
  end
end
