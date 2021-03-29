class VideoStory < ApplicationRecord
  include AASM
  include ApplicationHelper

  attr_accessor :location_ids, :place_category_ids, :story_category_ids

  has_many :video_story_locations, dependent: :destroy
  has_many :locations, through: :video_story_locations
  has_many :video_story_story_categories, dependent: :destroy
  has_many :story_categories, through: :video_story_story_categories
  has_many :video_story_place_categories, dependent: :destroy
  has_many :place_categories, through: :video_story_place_categories
  has_many :published_items, as: :publishable

  validates :video_url, :uniqueness => { :message => "Duplicate URL" }
  validates :video_url, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :editor_tagline, presence: true

  aasm column: :state do
    state :no_status, initial: true
    state :needs_review
    state :do_not_publish
    state :completed
    state :removed_from_public

    # after_all_transitions :log_status_change

    event :request_review do
      transitions from: [:no_status, :do_not_publish, :completed, :removed_from_public], to: :needs_review
    end

    event :hide do
      transitions from: [:no_status, :needs_review, :completed, :removed_from_public], to: :do_not_publish
    end

    event :complete do
      transitions from: [:no_status, :needs_review, :do_not_publish, :removed_from_public], to: :completed
    end

    event :remove do
      transitions from: [:no_status, :needs_review, :do_not_publish, :completed], to: :removed_from_public
    end

    event :reset do
      transitions from: [:needs_review, :do_not_publish, :completed, :removed_from_public], to: :no_status
    end
  end

  def destroy_published_item
    published_items.destroy_all if published_items.present?
  end

  def create_published_item
    PublishedItem.create(publishable: self, publish_at: (Date.today + 1).beginning_of_day)
  end

end
