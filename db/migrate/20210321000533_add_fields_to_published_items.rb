class AddFieldsToPublishedItems < ActiveRecord::Migration[6.1]
  def change
    add_column :published_items, :queued_at, :datetime
    add_column :published_items, :posted_at, :datetime

    add_index :published_items, :queued_at
    add_index :published_items, :posted_at

    remove_column :published_items, :position
  end
end
