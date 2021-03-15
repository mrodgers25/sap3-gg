class AddQueuePositionToPublishedItems < ActiveRecord::Migration[6.1]
  def change
    add_column :published_items, :queue_position, :integer
    add_index :published_items, :queue_position
  end
end
