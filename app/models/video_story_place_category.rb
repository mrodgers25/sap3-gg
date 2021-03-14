class VideoStoryPlaceCategory < ApplicationRecord
  validates :video_story_id, :place_category_id, presence: true
  validates :video_story_id, uniqueness: {scope: :place_category_id}

  belongs_to :video_story
  belongs_to :place_category
end
