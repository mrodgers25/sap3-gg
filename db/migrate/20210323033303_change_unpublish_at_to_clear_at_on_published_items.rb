class ChangeUnpublishAtToClearAtOnPublishedItems < ActiveRecord::Migration[6.1]
  def change
    rename_column :published_items, :unpublish_at, :clear_at
  end
end
