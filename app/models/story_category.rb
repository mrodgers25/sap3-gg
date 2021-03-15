class StoryCategory < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :story_story_categories, dependent: :destroy
  has_many :stories, through: :story_story_categories
  has_many :video_story_story_categories, dependent: :destroy
  has_many :video_stories, through: :video_story_story_categories
end
