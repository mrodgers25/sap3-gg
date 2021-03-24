class AddThumbnailUrlToVideoStories < ActiveRecord::Migration[6.1]
  def change
    add_column :video_stories, :thumbnail_url, :string
  end
end
