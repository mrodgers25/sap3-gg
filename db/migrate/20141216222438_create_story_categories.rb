class CreateStoryCategories < ActiveRecord::Migration
  def change
    create_table :story_categories do |t|
      t.string :code, null: false
      t.string :name
      t.timestamps
    end
    add_index :story_categories, :code, unique: true
  end
end
