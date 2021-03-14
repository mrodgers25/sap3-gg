class VideoStoryLocation < ApplicationRecord
  validates :video_story_id, :location_id, presence: true
  validates :video_story_id, uniqueness: {scope: :location_id}

  belongs_to :video_story
  belongs_to :location
end
