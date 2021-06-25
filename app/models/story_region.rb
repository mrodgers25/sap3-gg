class StoryRegion < ApplicationRecord
  validates :code, presence: true
  validates :code, uniqueness: true

  has_many :stories_story_regions, dependent: :destroy
  has_many :stories, through: :stories_story_regions
end
