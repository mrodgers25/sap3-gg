class AddStateToPublishedItems < ActiveRecord::Migration[6.1]
  def change
    add_column :published_items, :state, :string, default: 'queued'
    add_index :published_items, :state

    PublishedItem.update_all(state: 'displaying', displayed_at: Time.zone.now)
  end
end
