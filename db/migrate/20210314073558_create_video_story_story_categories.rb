class CreateVideoStoryStoryCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :video_story_story_categories do |t|
      t.integer :video_story_id, null: false
      t.integer :story_category_id, null: false
      t.timestamps
    end
    add_index :video_story_story_categories, [:video_story_id, :story_category_id], unique: true, name: :idx_video_story_story_categories
  end
end
