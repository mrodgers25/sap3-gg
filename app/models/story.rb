class Story < ActiveRecord::Base
  include ApplicationHelper
  # validates :editor_tagline, :presence => { :message => "EDITOR TAGLINE is required" }

  attr_accessor :location_ids, :place_category_ids, :story_category_ids

  has_many :urls, inverse_of: :story
  accepts_nested_attributes_for :urls
  has_many :usersavedstories
  accepts_nested_attributes_for :usersavedstories

  has_many :story_locations, dependent: :destroy
  has_many :locations, through: :story_locations

  has_many :story_story_categories, dependent: :destroy
  has_many :story_categories, through: :story_story_categories

  has_many :story_place_categories, dependent: :destroy
  has_many :place_categories, through: :story_place_categories

  attr_accessor :source_url_pre, :data_entry_begin_time, :raw_author_scrape, :raw_story_year_scrape, :raw_story_month_scrape, :raw_story_date_scrape

  before_validation :set_story_track_fields, on: :create
  before_save :set_story_complete

  def set_story_track_fields
    self.author_track = (self.raw_author_scrape == self.author) ? true : false
    if self.data_entry_begin_time.present?
      self.data_entry_time = (Time.now - self.data_entry_begin_time.to_time).round.to_i
    end
    self.story_year_track = (self.raw_story_year_scrape.to_i == self.story_year.to_i) ? true : false
    self.story_month_track = (self.raw_story_month_scrape.to_i == self.story_month.to_i) ? true : false
    self.story_date_track  = (self.raw_story_date_scrape.to_i == self.story_date.to_i) ? true : false
    true  # this returns a true at the end of the method; otherwise method fails if last statement is false
  end

  def set_story_complete
    self.story_complete = story_url_complete?
  end

  def story_url_complete?

    story_is_complete = Story.where("id = #{self.id} \
    and (story_year is not null \
    or story_month is not null \
    or story_date is not null) \
    and (location_code != '' \
    or place_category != '' \
    or story_category != '') \
    and editor_tagline is not null").present?

    url_is_complete = Url.where("story_id = #{self.id} \
    and url_type != '' \
    and url_title  != '' \
    and url_desc != '' \
    and url_domain != '' ").present?

    if (story_is_complete && url_is_complete)
      return true
    else
      return false
    end

  end

end
