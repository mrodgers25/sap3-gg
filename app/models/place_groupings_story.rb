class PlaceGroupingsStory < ApplicationRecord
  validates :story_id, :place_grouping_id, presence: true
  validates :story_id, uniqueness: {scope: :place_grouping_id}

  belongs_to :story
  belongs_to :place_grouping
end
