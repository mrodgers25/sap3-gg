# frozen_string_literal: true

class Url < ApplicationRecord
  attr_accessor :raw_url_title_scrape, :raw_url_desc_scrape, :raw_url_keywords_scrape

  belongs_to :story, inverse_of: :urls
  has_many :images, inverse_of: :url
  has_one :media_owner, foreign_key: 'url_domain', primary_key: 'url_domain'

  before_validation :set_track_fields, on: :create
  validates :url_full, uniqueness: { message: 'Duplicate URL' }
  validates :url_title, :url_desc, presence: true

  accepts_nested_attributes_for :images

  def set_track_fields
    self.url_title_track = (raw_url_title_scrape == url_title)
    self.url_desc_track = (raw_url_desc_scrape == url_desc)
    self.url_keywords_track = (raw_url_keywords_scrape == url_keywords)
  end

  def encoded_url
    URI.encode(url_full)
  end

  def latest_image_url
    images.order(:id).last.src_url
  end
end
