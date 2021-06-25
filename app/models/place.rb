# frozen_string_literal: true

# TODO(alishaevn): add a comment on what this is about
class Place < ApplicationRecord
  attr_accessor :story_id

  belongs_to :address
  belongs_to :place_status_option

  accepts_nested_attributes_for :address, reject_if: :all_blank

  has_many :story_places, dependent: :destroy
  has_many :stories, through: :story_places

  validates :name, :place_status_option_id, presence: true
end
