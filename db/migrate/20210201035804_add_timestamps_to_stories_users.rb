class AddTimestampsToStoriesUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :stories_users, :id, :primary_key
    add_timestamps :stories_users, null: false, default: -> { 'NOW()' }
  end
end
