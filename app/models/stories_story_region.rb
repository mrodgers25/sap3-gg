class StoriesStoryRegion < ApplicationRecord
  belongs_to :story
  belongs_to :story_region

  validates :story_id, :story_region_id, presence: true
  validates :story_id, uniqueness: { scope: :story_region_id }
end
