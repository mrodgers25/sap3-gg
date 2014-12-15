class Story < ActiveRecord::Base
  has_many :urls, inverse_of: :story
  accepts_nested_attributes_for :urls
  has_many :usersavedstories
  accepts_nested_attributes_for :usersavedstories

  validates :editor_tagline, :presence => { :message => "EDITOR TAGLINE is required" }

  # landing page dropdown
  scope :user_location_code, -> (user_location_code) { where("location_code in (?)", "#{user_location_code.upcase.gsub(/,/, "','")}")}
  scope :user_place_category, -> (user_place_category) { where("place_category = ?", "#{user_place_category.upcase}")}
  scope :user_story_category, -> (user_story_category) { where("story_category = ?", "#{user_story_category.upcase}")}

  attr_accessor :source_url_pre, :data_entry_begin_time, :raw_author_scrape, :raw_story_year_scrape, :raw_story_month_scrape, :raw_story_date_scrape

  before_validation :set_story_track_fields, on: :create

  def set_story_track_fields
    self.author_track = (self.raw_author_scrape == self.author) ? true : false
    self.data_entry_time = (Time.now - self.data_entry_begin_time.to_time).round.to_i
    self.story_year_track = (self.raw_story_year_scrape.to_i == self.story_year.to_i) ? true : false
    self.story_month_track = (self.raw_story_month_scrape.to_i == self.story_month.to_i) ? true : false
    self.story_date_track  = (self.raw_story_date_scrape.to_i == self.story_date.to_i) ? true : false
    true  # this returns a true at the end of the method; otherwise method fails if last statement is false
  end

end
