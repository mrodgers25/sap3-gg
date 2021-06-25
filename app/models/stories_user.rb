# frozen_string_literal: true

class StoriesUser < ApplicationRecord
  belongs_to :story
  belongs_to :user
end
