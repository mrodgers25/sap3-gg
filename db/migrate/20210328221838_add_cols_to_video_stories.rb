class AddColsToVideoStories < ActiveRecord::Migration[6.1]
  def change
    add_column :video_stories, :views, :integer
    add_column :video_stories, :subscribers, :integer
    add_column :video_stories, :unlisted, :boolean, default: false
    add_column :video_stories, :likes, :integer, default: 0
    add_column :video_stories, :dislikes, :integer, default: 0
  end
end
