class Story < ActiveRecord::Base
  has_many :urls, inverse_of: :story
  accepts_nested_attributes_for :urls

  validates :story_type, presence: true
  # validates :author, presence: true

  attr_accessor :source_url_pre, :raw_author_scrape, :raw_story_year_scrape, :raw_story_month_scrape, :raw_story_date_scrape

  before_validation :set_story_track_fields, on: :create

  def set_story_track_fields
    self.author_track = (self.raw_author_scrape == self.author) ? true : false
    self.story_year_track = (self.raw_story_year_scrape.to_i == self.story_year.to_i) ? true : false
    self.story_month_track = (self.raw_story_month_scrape.to_i == self.story_month.to_i) ? true : false
    self.story_date_track  = (self.raw_story_date_scrape.to_i == self.story_date.to_i) ? true : false
    true  # this returns a true at the end of the method; otherwise method fails if last statement is false
  end

end
