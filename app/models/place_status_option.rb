# frozen_string_literal: true

class PlaceStatusOption < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
end
