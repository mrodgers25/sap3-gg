class AddInternalImageWidthAndHeightToStories < ActiveRecord::Migration[6.1]
  def change
    add_column :stories, :internal_image_width, :integer
    add_column :stories, :internal_image_height, :integer
  end
end
