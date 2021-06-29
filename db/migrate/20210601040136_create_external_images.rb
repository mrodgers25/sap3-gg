class CreateExternalImages < ActiveRecord::Migration[6.1]
  def change
    create_table :external_images do |t|
      t.integer :story_id
      t.string  :src_url
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
