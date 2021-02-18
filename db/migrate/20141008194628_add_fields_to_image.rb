class AddFieldsToImage < ActiveRecord::Migration[6.0]
  def change
    add_column :images, :image_width, :integer
    add_column :images, :image_height, :integer
  end
end
