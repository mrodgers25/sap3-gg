class RemoveUrlFromStories < ActiveRecord::Migration
  def change
    remove_column :stories, :url_id, :string
  end
end
