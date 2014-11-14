class RemoveDataEntryFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :data_entry_user, :string
  end
end
