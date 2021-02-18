class Url < ApplicationRecord
  belongs_to :story, inverse_of: :urls
  # validates :url_type, presence: true
  # validates :url_title, :presence => { :message => "TITLE is required" }
  # validates :url_desc, :presence => { :message => "DESCRIPTION is required" }
  # validates :url_domain, presence: true
  validates :url_full, :uniqueness => { :message => "Duplicate URL" }

  has_many :images, inverse_of: :url
  accepts_nested_attributes_for :images

  has_one :mediaowner, foreign_key: "url_domain", primary_key: "url_domain"

  attr_accessor :raw_url_title_scrape, :raw_url_desc_scrape, :raw_url_keywords_scrape

  before_validation :set_track_fields, on: :create

  def set_track_fields
    self.url_title_track = (self.raw_url_title_scrape == self.url_title ? true : false)
    self.url_desc_track = (self.raw_url_desc_scrape == self.url_desc ? true : false)
    self.url_keywords_track = (self.raw_url_keywords_scrape == self.url_keywords ? true : false)
  end

  def encoded_url
    URI.encode(url_full)
  end

end
