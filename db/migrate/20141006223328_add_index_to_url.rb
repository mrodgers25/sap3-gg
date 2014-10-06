class AddIndexToUrl < ActiveRecord::Migration
  def change
    add_index :urls, :url_full, :unique => true
  end
end
