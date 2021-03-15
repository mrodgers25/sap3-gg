class Location < ApplicationRecord
  validates :code, presence: true
  validates :code, uniqueness: true

  has_many :story_locations, dependent: :destroy
  has_many :stories, through: :story_locations
  has_many :video_story_locations, dependent: :destroy
  has_many :video_stories, through: :video_story_locations

end
