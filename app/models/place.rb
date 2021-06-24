# frozen_string_literal: true

# TODO(alishaevn): add a comment on what this is about
class Place < ApplicationRecord
  belongs_to :address
  accepts_nested_attributes_for :address

  belongs_to :place_status_option
  # has_many :stories

  validates :name, :place_status_option_id, presence: true
end
