class AddDatefieldsToUsersavedstories < ActiveRecord::Migration
  def change
    add_column :usersavedstories, :created_at, :datetime
    add_column :usersavedstories, :updated_at, :datetime
  end
end
