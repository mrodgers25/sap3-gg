class RenameAddress < ActiveRecord::Migration[6.1]
  def change
    rename_table :addresses, :locations
    rename_column :places, :address_id, :location_id
  end
end
