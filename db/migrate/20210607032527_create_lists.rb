class CreateLists < ActiveRecord::Migration[6.1]
  def change
    create_table :lists do |t|
      t.integer :story_id

      t.timestamps

      t.index :story_id
    end
  end
end
