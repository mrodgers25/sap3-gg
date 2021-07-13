# frozen_string_literal: true

class StoryPlace < ApplicationRecord
  belongs_to :story
  belongs_to :place
end
