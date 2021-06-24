class CreatePlaceStatusOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :place_status_options do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
