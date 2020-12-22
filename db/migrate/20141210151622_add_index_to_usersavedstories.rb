class AddIndexToUsersavedstories < ActiveRecord::Migration[6.0]
  def change
    add_index :usersavedstories, [:user_id, :story_id], unique: true
  end
end
