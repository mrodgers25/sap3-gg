class PlaceGrouping < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :place_groupings_stories, dependent: :destroy
  has_many :stories, through: :place_groupings_stories
end
