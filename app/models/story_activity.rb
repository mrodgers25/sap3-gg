# frozen_string_literal: true

class StoryActivity < ApplicationRecord
  belongs_to :story
  belongs_to :user, optional: true
end
