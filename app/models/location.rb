class Location < ActiveRecord::Base
  validates :code, presence: true
  validates :code, uniqueness: true

  has_many :story_locations, dependent: :destroy
  has_many :stories, through: :story_locations

end
