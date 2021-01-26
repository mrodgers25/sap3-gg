class AddFIndexToImage < ActiveRecord::Migration[6.0]
  def change
    add_index :images, :url_id
  end
end
