class AddDescLengthToVideoStories < ActiveRecord::Migration[6.1]
  def change
    add_column :video_stories, :desc_length, :integer, default: 200
  end
end
