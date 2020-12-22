class CreatePlaceCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :place_categories do |t|
      t.string :code, null: false
      t.string :name
      t.timestamps
    end
    add_index :place_categories, :code, unique: true
  end
end
