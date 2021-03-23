class PublishedItem < ApplicationRecord
  include AASM

  belongs_to :publishable, polymorphic: true

  validates_uniqueness_of :publishable_id, scope: :publishable_type

  aasm column: :state do
    state :displaying, initial: true
    state :queued
    state :newsfeed

    event :queue do
      transitions from: :displaying, to: :queued, after: Proc.new {|*args| update_after_queue }
    end

    event :remove do
      transitions from: :queued, to: :displaying, after: Proc.new {|*args| update_after_remove }
    end

    event :post do
      transitions from: :queued, to: :newsfeed, after: Proc.new {|*args| update_after_post }
    end

    event :clear do
      transitions from: :newsfeed, to: :displaying, after: Proc.new {|*args| update_after_clear }
    end
  end

  def self.all_states
    self.aasm.states.map{|x| x.name.to_s }
  end

  def update_after_queue
    last_queue_position = PublishedItem.where(state: 'queued').pluck(:queue_position).max || 0
    self.update(queue_position: last_queue_position + 1, queued_at: Time.zone.now)
  end

  def update_after_remove
    position_was_set = self.queue_position.present?
    self.update(queue_position: nil, queued_at: nil)
    PublishedItem.resequence_all_queue_positions if position_was_set
  end

  def update_after_post
    position_was_set = self.queue_position.present?
    track_newsfeed_start
    run_pinned_action_sequence if self.pinned?
    self.update(queue_position: nil, queued_at: nil, pinned_action: nil, posted_at: Time.zone.now)
    PublishedItem.resequence_all_queue_positions if position_was_set
  end

  def update_after_clear
    track_newsfeed_end
    self.update(posted_at: nil, pinned: false)
  end

  def self.resequence_all_queue_positions
    sorted_by_position = PublishedItem.where(state: 'queued').where.not(queue_position: nil).order(queue_position: :asc, updated_at: :desc)
    sorted_by_position.each_with_index do |queued_item, index|
      new_position = index + 1
      queued_item.update(queue_position: new_position)
    end
  end

  def run_pinned_action_sequence
    old_pinned_item = PublishedItem.where(pinned: true).where.not(id: id).order(:posted_at).last
    return unless old_pinned_item

    if pinned_action.blank? || pinned_action == 'release'
      # trick the system to move it through natrually (by posted_at)
      old_pinned_item.update(posted_at: Time.zone.now, pinned: false, pinned_action: nil)
    else
      # replace the old pinned item
      old_pinned_item.clear!
    end
  end

  def track_newsfeed_start
    #Activity: publishable type, publishable id, activity_type, newsfeed
    # create posted activity for publishable type (track the amount of posts for each publishable item)
    true
  end

  def track_newsfeed_end
    #Activity: publishable type, publishable id, activity_type, newsfeed
    # track how long the item was posted for and the settings it was posted with
    true
  end
end
