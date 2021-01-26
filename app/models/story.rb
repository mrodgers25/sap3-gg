class Story < ApplicationRecord
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

  has_one :mediaowner, through: :urls

  attr_accessor :source_url_pre, :data_entry_begin_time, :raw_author_scrape, :raw_story_year_scrape, :raw_story_month_scrape, :raw_story_date_scrape

  before_validation :set_story_track_fields, on: :create

  after_validation :set_story_complete

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |result|
        csv << result.attributes.values_at(*column_names)
      end
    end
  end


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
    story_check = (self.editor_tagline != '' and
        (self.story_year != nil or self.story_month != nil or self.story_date != nil) and
        (self.urls.first.url_type != '' and self.urls.first.url_title != '' and self.urls.first.url_desc != '' and self.urls.first.url_domain != ''))
    write_attribute(:story_complete, story_check ? true : false)
    # binding.pry
  end

  def story_url_complete?  # currently not used
    where_str = "(spc.story_id IS NOT NULL)"
    where_str += " AND (stories.story_year IS NOT NULL OR stories.story_month IS NOT NULL OR stories.story_date IS NOT NULL)"  # at least one date value
    where_str += " AND stories.editor_tagline != '' "
    where_str += " AND (urls.url_type != '' AND urls.url_title != '' AND urls.url_desc != '' AND urls.url_domain != '')"
    where_str += " AND stories.id = #{self.id}"

    Story.joins("LEFT OUTER JOIN story_locations sl ON (stories.id = sl.story_id)")
    .joins("LEFT OUTER JOIN story_place_categories spc ON (stories.id = spc.story_id)")
    .joins("LEFT OUTER JOIN story_story_categories ssc ON (stories.id = ssc.story_id)")
    .joins(:urls)
    .where(where_str).present?

  end

  def latest_image
    latest_url.images.order(:created_at).last
  end

  def latest_url
    urls.order(:created_at).last
  end

  def story_display_date
    if story_month && story_date && story_year
      "#{story_month}/#{story_date}/#{story_year}"
    elsif story_month && story_year
      "#{story_month}/#{story_year}"
    else
      nil
    end
  end

  def media_owner_and_date_line
    if latest_url.mediaowner&.title
      "#{latest_url.mediaowner.title} - #{story_display_date}"
    else
      story_display_date
    end
  end

  def display_location
    locations.pluck(:name).join(', ')
  end

  def display_publisher
    return nil unless latest_url.mediaowner.present?

    latest_url.mediaowner&.title
  end

  def display_place_categories
    place_categories.pluck(:name).join(', ')
  end

  def display_story_categories
    story_categories.pluck(:name).join(', ')
  end
end
