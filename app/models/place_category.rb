# frozen_string_literal: true

class PlaceCategory < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :story_place_categories, dependent: :destroy
  has_many :stories, through: :story_place_categories
end
