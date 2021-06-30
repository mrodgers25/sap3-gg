class AddCategoryToPlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :places, :category_id, :integer
    add_index :places, :category_id
  end
end
