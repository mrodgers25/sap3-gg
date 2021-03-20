class PublishedItem < ApplicationRecord
  include AASM

  belongs_to :publishable, polymorphic: true

  validates_uniqueness_of :publishable_id, scope: :publishable_type

  aasm column: :state do
    state :displaying, initial: true
    state :queued
    state :newsfeed

    event :post do
      transitions from: :queued, to: :newsfeed, after: Proc.new {|*args| track_newsfeed_start }
    end

    event :clear do
      transitions from: :newsfeed, to: :displaying, after: Proc.new {|*args| track_newsfeed_end }
    end
  end

  def set_display_values
    self.update(queue_position: nil, displayed_at: Time.zone.now)
  end

  def track_newsfeed_start
    #Activity: publishable type, publishable id, activity_type, newsfeed
    true
  end

  def track_newsfeed_end
    #Activity: publishable type, publishable id, activity_type, newsfeed
    true
  end

  def self.publish_rate
    # publish n amount stories per day
    1
  end

  def self.published_states
    ['displaying', 'queued', 'newsfeed', 'will_unpublish']
  end
end
