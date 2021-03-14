class CreateVideoStoryPlaceCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :video_story_place_categories do |t|
      t.integer :video_story_id, null: false
      t.integer :place_category_id, null: false
      t.timestamps
    end
    add_index :video_story_place_categories, [:video_story_id, :place_category_id], unique: true, name: :idx_video_story_place_categories
  end
end
