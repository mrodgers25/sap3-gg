class Place < ApplicationRecord
  belongs_to :address
  accepts_nested_attributes_for :address

  belongs_to :place_status_option
  has_many :stories

  validates :name, presence: true
  validates :place_status_option_id, presence: true
end
