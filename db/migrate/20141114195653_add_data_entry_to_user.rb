
class AddDataEntryToUser < ActiveRecord::Migration
  def change
    add_column :users, :data_entry_user, :string
  end
end
