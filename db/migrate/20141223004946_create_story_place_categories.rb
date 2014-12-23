class CreateStoryPlaceCategories < ActiveRecord::Migration
  def change
    create_table :story_place_categories do |t|
      t.integer :story_id, null: false
      t.integer :place_category_id, null: false
      t.timestamps
    end
    add_index :story_place_categories, [:story_id, :place_category_id], unique: true
  end
end
