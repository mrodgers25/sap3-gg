# frozen_string_literal: true

class StoryLocation < ApplicationRecord
  validates :story_id, :location_id, presence: true
  validates :story_id, uniqueness: { scope: :location_id }

  belongs_to :story
  belongs_to :location
end
