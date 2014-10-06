class AddFIndexToImage < ActiveRecord::Migration
  def change
    add_index :images, :url_id
  end
end
