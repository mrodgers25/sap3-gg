class RenameColumnOnPublishedItems < ActiveRecord::Migration[6.1]
  def change
    rename_column :published_items, :publish_at, :displayed_at
  end
end
