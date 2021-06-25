# frozen_string_literal: true

class Place < ApplicationRecord
  attr_accessor :story_id

  belongs_to :address
  accepts_nested_attributes_for :address, reject_if: :all_blank

  belongs_to :place_status_option

  has_many :story_places, dependent: :destroy
  has_many :stories, through: :story_places

  validates :name, presence: true
  validates :place_status_option_id, presence: true
end
