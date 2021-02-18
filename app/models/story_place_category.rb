class StoryPlaceCategory < ApplicationRecord
  validates :story_id, :place_category_id, presence: true
  validates :story_id, uniqueness: {scope: :place_category_id}

  belongs_to :story
  belongs_to :place_category
end
