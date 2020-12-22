
class AddDataEntryToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :data_entry_user, :string
  end
end
