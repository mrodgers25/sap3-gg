class Story < ActiveRecord::Base
  has_many :urls, inverse_of: :story
  accepts_nested_attributes_for :urls

  validates :story_type, presence: true
  validates :author, presence: true

  # attr_accessor :source_url_pre

  attr_accessor :source_url_pre, :raw_author_scrape, :raw_story_year_scrape, :raw_story_month_scrape, :raw_story_date_scrape

  before_validation :set_story_track_fields

  def set_story_track_fields
    # self.author_track = true  # save OK when this block is used
    # self.story_year_track = true
    # self.story_month_track = true
    # self.story_date_track = true

    self.author_track = (self.raw_author_scrape == self.author ? true : false) # begin, rollback no save when this block is used
    self.story_year_track = (self.raw_story_year_scrape == self.story_year ? true : false)
    self.story_month_track = (self.raw_story_month_scrape == self.story_month ? true : false)
    self.story_date_track = (self.raw_story_date_scrape == self.story_date ? true : false)
  end

end
