class CreateUserSavedStories < ActiveRecord::Migration[6.0]
  def change
    create_table :user_saved_stories do |t|
      t.string :user_id
      t.string :story_id
    end
  end
end
