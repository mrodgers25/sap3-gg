class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.float :latitude
      t.float :longitude
      t.string :street_address
      t.string :post_office_box_number
      t.string :locality
      t.string :region
      t.string :postal_code
      t.string :country
      t.string :custom_1
      t.string :custom_2

      t.timestamps
    end
  end
end
