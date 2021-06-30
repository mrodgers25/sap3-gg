# frozen_string_literal: true

class Place < ApplicationRecord
  attr_accessor :story_id

  belongs_to :location
  belongs_to :category, optional: true
  belongs_to :place_status_option, optional: true

  accepts_nested_attributes_for :location, reject_if: :all_blank

  has_many :story_places, dependent: :destroy
  has_many :stories, through: :story_places

  validates :name, presence: true

  include PgSearch::Model
  pg_search_scope :search,
                  against: [:name],
                  using: { tsearch: {any_word: true, prefix: true} }

end
