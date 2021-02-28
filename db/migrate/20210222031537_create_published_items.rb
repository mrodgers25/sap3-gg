class CreatePublishedItems < ActiveRecord::Migration[6.1]
  def change
    create_table :published_items do |t|
      t.integer  :publishable_id
      t.string   :publishable_type
      t.datetime :publish_at
      t.datetime :unpublish_at
      t.boolean  :pinned, default: false
      t.integer  :position

      t.timestamps

      t.index [:publishable_type, :publishable_id]
      t.index :pinned
      t.index :position
    end
  end
end
