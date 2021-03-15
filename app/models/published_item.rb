class PublishedItem < ApplicationRecord
  include AASM

  belongs_to :publishable, polymorphic: true

  validates_uniqueness_of :publishable_id, scope: :publishable_type

  aasm column: :state do
    state :queued, initial: true
    state :displaying

    event :post do
      transitions from: :queued, to: :displaying, after: Proc.new {|*args| set_display_values }
    end

    event :requeue do
      transitions from: :displaying, to: :queued
    end
  end

  def set_display_values
    self.update(queue_position: nil, displayed_at: Time.zone.now)
  end

  def self.publish_rate
    # publish n amount stories per day
    1
  end

  def self.published_states
    ['queued', 'displaying', 'will_unpublish']
  end
end
