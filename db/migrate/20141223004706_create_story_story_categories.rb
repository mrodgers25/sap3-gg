class CreateStoryStoryCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :story_story_categories do |t|
      t.integer :story_id, null: false
      t.integer :story_category_id, null: false
      t.timestamps
    end
    add_index :story_story_categories, [:story_id, :story_category_id], unique: true
  end
end
