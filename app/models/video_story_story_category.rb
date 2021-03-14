class VideoStoryStoryCategory < ApplicationRecord
  validates :video_story_id, :story_category_id, presence: true
  validates :video_story_id, uniqueness: {scope: :story_category_id}

  belongs_to :video_story
  belongs_to :story_category
end
