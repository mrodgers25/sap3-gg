class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.text :src_url
      t.text :alt_text

      t.timestamps
    end
  end
end
