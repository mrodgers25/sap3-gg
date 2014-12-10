class ChangecolumnsUsersavedstories < ActiveRecord::Migration
  def change
    remove_column :usersavedstories, :story_id
    remove_column :usersavedstories, :user_id
    add_column :usersavedstories, :story_id, :integer
    add_column :usersavedstories, :user_id, :integer
  end
end
