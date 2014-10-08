class AddFieldsToImage < ActiveRecord::Migration
  def change
    add_column :images, :image_width, :integer
    add_column :images, :image_height, :integer
  end
end
