class Story < ApplicationRecord
  include AASM
  include ApplicationHelper

  attr_accessor :location_ids, :place_category_ids, :story_category_ids, :source_url_pre, :data_entry_begin_time,
                :raw_author_scrape, :raw_story_year_scrape, :raw_story_month_scrape, :raw_story_date_scrape

  has_and_belongs_to_many :users
  has_many :urls, inverse_of: :story, dependent: :destroy
  accepts_nested_attributes_for :urls
  has_many :story_locations, dependent: :destroy
  has_many :locations, through: :story_locations
  has_many :story_places, dependent: :destroy
  has_many :places, through: :story_places
  has_many :story_story_categories, dependent: :destroy
  has_many :story_categories, through: :story_story_categories
  has_many :story_place_categories, dependent: :destroy
  has_many :place_categories, through: :story_place_categories
  has_many :story_activities, dependent: :destroy
  has_many :published_items, as: :publishable
  has_many :newsfeed_activities, as: :trackable
  has_one :media_owner, through: :urls

  before_validation :set_story_track_fields, on: :create
  after_validation :set_story_complete
  after_update :check_state_and_update_published_item

  aasm column: :state do
    state :no_status, initial: true
    state :completed
    state :needs_review
    state :do_not_publish
    state :removed_from_public

    after_all_transitions :log_status_change

    event :request_review do
      transitions from: %i[no_status do_not_publish completed removed_from_public], to: :needs_review
    end

    event :hide do
      transitions from: %i[no_status needs_review completed removed_from_public], to: :do_not_publish
    end

    event :complete do
      transitions from: %i[no_status needs_review do_not_publish removed_from_public], to: :completed
    end

    event :remove do
      transitions from: %i[no_status needs_review do_not_publish completed], to: :removed_from_public
    end

    event :reset do
      transitions from: %i[needs_review do_not_publish completed removed_from_public], to: :no_status
    end
  end

  def media_story?
    type == 'MediaStory'
  end

  def video_story?
    type == 'VideoStory'
  end

  def check_state_and_update_published_item
    'completed' == state ? create_published_item : destroy_published_item
  end

  def create_published_item
    PublishedItem.create(publishable: self)
  end

  def destroy_published_item
    published_items.destroy_all if published_items.present?
  end

  def log_status_change
    StoryActivity.create!(story_id: id, from: aasm.from_state.to_s, to: aasm.to_state.to_s,
                          event: aasm.current_event.to_s)
  end

  def self.all_types
    %w[MediaStory VideoStory CustomStory]
  end

  def self.all_states
    aasm.states.map { |x| x.name.to_s }
  end

  def self.all_states_mapping
    aasm.states.map do |state|
      [state.name.to_s.titleize, state.name.to_s]
    end
  end

  def should_not_be_displayed?
    published_items.blank?
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.find_each do |result|
        csv << result.attributes.values_at(*column_names)
      end
    end
  end

  def set_story_track_fields
    self.author_track = raw_author_scrape == author
    self.data_entry_time = (Time.now - data_entry_begin_time.to_time).round.to_i if data_entry_begin_time.present?
    self.story_year_track = raw_story_year_scrape.to_i == story_year.to_i
    self.story_month_track = raw_story_month_scrape.to_i == story_month.to_i
    self.story_date_track  = raw_story_date_scrape.to_i == story_date.to_i
    true  # this returns a true at the end of the method; otherwise method fails if last statement is false
  end

  def set_story_complete
    story_check = (editor_tagline != '' and
        (!story_year.nil? or !story_month.nil? or !story_date.nil?) and
        (urls.first.url_type != '' and urls.first.url_title != '' and urls.first.url_desc != '' and urls.first.url_domain != ''))
    self[:story_complete] = story_check ? true : false
  end

  # currently not used
  def story_url_complete?
    where_str = '(spc.story_id IS NOT NULL)'
    where_str += ' AND (stories.story_year IS NOT NULL OR stories.story_month IS NOT NULL OR stories.story_date IS NOT NULL)'  # at least one date value
    where_str += " AND stories.editor_tagline != '' "
    where_str += " AND (urls.url_type != '' AND urls.url_title != '' AND urls.url_desc != '' AND urls.url_domain != '')"
    where_str += " AND stories.id = #{id}"

    Story.joins('LEFT OUTER JOIN story_locations sl ON (stories.id = sl.story_id)')
         .joins('LEFT OUTER JOIN story_place_categories spc ON (stories.id = spc.story_id)')
         .joins('LEFT OUTER JOIN story_story_categories ssc ON (stories.id = ssc.story_id)')
         .joins(:urls)
         .where(where_str).present?
  end

  def latest_image
    latest_url&.images&.order(:created_at)&.last
  end

  def latest_url
    urls.order(:created_at).last
  end

  def image_width
    latest_url.images.first.image_width
  end

  def image_height
    latest_url.images.first.image_height
  end

  def title
    latest_url.url_title
  end

  def story_display_date
    if story_month && story_date && story_year
      "#{story_month}/#{story_date}/#{story_year}"
    elsif story_month && story_year
      "#{story_month}/#{story_year}"
    end
  end

  def media_owner
    latest_url&.media_owner&.title
  end

  def media_owner_and_date_line
    if latest_url&.media_owner&.title
      "#{latest_url.media_owner.title} - #{story_display_date}"
    else
      story_display_date
    end
  end

  def display_location
    locations.pluck(:name).join(', ')
  end

  def display_location_codes
    locations.pluck(:code).join(', ')
  end

  def display_publisher
    return nil unless latest_url.media_owner.present?

    latest_url.media_owner&.title
  end

  def display_place_categories
    place_categories.pluck(:name).join(', ')
  end

  def display_story_categories
    story_categories.pluck(:name).join(', ')
  end

  def create_permalink
    url_title = latest_url.url_title.parameterize
    rand_hex = SecureRandom.hex(2)
    permalink = "#{rand_hex}/#{url_title}"
    update_attribute(:permalink, permalink.to_s)
  end
end
