class RenameUserSavedStories < ActiveRecord::Migration
  def change
    rename_table :user_saved_stories, :usersavedstories
  end
end
