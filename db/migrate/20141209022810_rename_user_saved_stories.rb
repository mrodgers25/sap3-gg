class RenameUserSavedStories < ActiveRecord::Migration[6.0]
  def change
    rename_table :user_saved_stories, :usersavedstories
  end
end
