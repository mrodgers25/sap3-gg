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
  validates :author, presence: true
  validates :description, presence: true





  aasm column: :state do
    state :draft, initial: true
    state :approved
    state :published
    state :archived

    event :approve do
      # small hack for review screen, published added for ease of use
      transitions from: [:draft, :published], to: :approved, after: Proc.new {|*args| destroy_published_item }
    end

    event :disapprove do
      transitions from: [:approved, :published], to: :draft, after: Proc.new {|*args| destroy_published_item }
    end

    event :publish do
      # small hack for review screen, draft added for ease of use
      transitions from: [:draft, :approved], to: :published, after: Proc.new {|*args| create_published_item }
    end

    event :unpublish do
      transitions from: :published, to: :approved, after: Proc.new {|*args| destroy_published_item }
    end

    event :archive do
      transitions from: [:approved, :published], to: :archived, after: Proc.new {|*args| destroy_published_item }
    end

    event :revive do
      transitions from: :archived, to: :approved
    end
  end

  def destroy_published_item
    published_items.destroy_all if published_items.present?
  end

  def create_published_item
    PublishedItem.create(publishable: self, publish_at: (Date.today + 1).beginning_of_day)
  end

end
