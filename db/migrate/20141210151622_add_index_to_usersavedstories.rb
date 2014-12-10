class AddIndexToUsersavedstories < ActiveRecord::Migration
  def change
    add_index :usersavedstories, [:user_id, :story_id], unique: true
  end
end
