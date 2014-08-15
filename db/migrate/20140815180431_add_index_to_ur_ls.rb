class AddIndexToUrLs < ActiveRecord::Migration
  def change
    add_index :urls, :url, unique: true
  end
end
