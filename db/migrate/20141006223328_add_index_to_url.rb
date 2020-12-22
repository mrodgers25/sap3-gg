class AddIndexToUrl < ActiveRecord::Migration[6.0]
  def change
    add_index :urls, :url_full, :unique => true
  end
end
