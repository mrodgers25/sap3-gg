class CreatePlaces < ActiveRecord::Migration[6.1]
  def change
    create_table :places do |t|
      t.string :name, null: false
      t.references :address, null: false, foreign_key: true
      t.references :place_status_option, null: false, foreign_key: true
      t.integer :imported_place_id

      t.timestamps
    end
  end
end
