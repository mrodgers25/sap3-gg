class RemoveDataEntryFromUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :data_entry_user, :string
  end
end
