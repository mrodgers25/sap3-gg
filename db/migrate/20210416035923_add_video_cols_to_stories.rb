class AddVideoColsToStories < ActiveRecord::Migration[6.1]
  def change
    add_column :stories, :type, :string
    add_column :stories, :hashtags, :text
    add_column :stories, :video_creator, :string
    add_column :stories, :video_channel_id, :string
    add_column :stories, :video_duration, :integer, default: 0
    add_column :stories, :video_hashtags, :text
    add_column :stories, :video_views, :integer
    add_column :stories, :video_subscribers, :integer
    add_column :stories, :video_unlisted, :boolean, default: false
    add_column :stories, :video_likes, :integer, default: 0
    add_column :stories, :video_dislikes, :integer, default: 0
  end
end
