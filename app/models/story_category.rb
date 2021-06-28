# frozen_string_literal: true

class StoryCategory < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :story_story_categories, dependent: :destroy
  has_many :stories, through: :story_story_categories
end
