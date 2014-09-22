class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.text :src_url
      t.text :alt_text

      t.timestamps
    end
  end
end
