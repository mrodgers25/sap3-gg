class CreateListItems < ActiveRecord::Migration[6.1]
  def change
    create_table :list_items do |t|
      t.integer :list_id
      t.integer :story_id
      t.integer :position

      t.timestamps

      t.index :list_id
      t.index :story_id
      t.index :position
    end
  end
end
