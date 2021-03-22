class AddPinnedActionToPublishedItems < ActiveRecord::Migration[6.1]
  def change
    add_column :published_items, :pinned_action, :string, default: 'release'
  end
end
