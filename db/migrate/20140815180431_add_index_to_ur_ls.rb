class AddIndexToUrLs < ActiveRecord::Migration[6.0]
  def change
    add_index :urls, :url, unique: true
  end
end
