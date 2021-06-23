class PublishedItem < ApplicationRecord
  include AASM

  belongs_to :publishable, polymorphic: true

  validates :publishable_id, uniqueness: { scope: :publishable_type }

  aasm column: :state do
    state :displaying, initial: true
    state :queued
    state :newsfeed

    event :queue do
      transitions from: :displaying, to: :queued, after: proc { |*_args| update_after_queue }
    end

    event :remove do
      transitions from: :queued, to: :displaying, after: proc { |*_args| update_after_remove }
    end

    event :post do
      transitions from: :queued, to: :newsfeed, after: proc { |*_args| update_after_post }
    end

    event :clear do
      transitions from: :newsfeed, to: :displaying, after: proc { |*_args| update_after_clear }
    end
  end

  def self.all_states
    aasm.states.map { |x| x.name.to_s }
  end

  def update_after_queue
    last_queue_position = PublishedItem.where(state: 'queued').pluck(:queue_position).max || 0
    update(queue_position: last_queue_position + 1, queued_at: Time.zone.now)
  end

  def update_after_remove
    position_was_set = queue_position.present?
    update(queue_position: nil, queued_at: nil)
    PublishedItem.resequence_all_queue_positions if position_was_set
  end

  def update_after_post
    position_was_set = queue_position.present?
    track_post
    run_pinned_action_sequence if pinned?
    update(queue_position: nil, queued_at: nil, pinned_action: nil, posted_at: Time.zone.now)
    PublishedItem.resequence_all_queue_positions if position_was_set
  end

  def update_after_clear
    track_clear
    update(posted_at: nil, pinned: false)
  end

  def self.resequence_all_queue_positions
    sorted_by_position = PublishedItem.where(state: 'queued').where.not(queue_position: nil).order(
      queue_position: :asc, updated_at: :desc
    )
    sorted_by_position.each_with_index do |queued_item, index|
      new_position = index + 1
      queued_item.update(queue_position: new_position)
    end
  end

  def run_pinned_action_sequence
    old_pinned_item = PublishedItem.where(pinned: true).where.not(id: id).order(:posted_at).last
    return unless old_pinned_item

    # track pinned length
    track_unpin(old_pinned_item)

    if pinned_action.blank? || pinned_action == 'release'
      # trick the system to move it through natrually (by posted_at)
      old_pinned_item.update(posted_at: Time.zone.now, pinned: false, pinned_action: nil)
    else
      # replace the old pinned item
      old_pinned_item.clear!
    end
  end

  def track_unpin(old_pinned_item)
    time_pinned = old_pinned_item.posted_at ? Time.zone.now.to_time - old_pinned_item.posted_at.to_time : 0

    NewsfeedActivity.create!(
      trackable_id: old_pinned_item.publishable_id,
      trackable_type: old_pinned_item.publishable_type,
      posted_at: old_pinned_item.posted_at,
      activity_type: 'unpin',
      pinned: false,
      pinned_action: pinned_action,
      time_pinned: time_pinned,
      details: "Unpinned item. Action: #{pinned_action}"
    )
  end

  def track_post
    action = pinned ? pinned_action : nil

    NewsfeedActivity.create(
      trackable_id: publishable_id,
      trackable_type: publishable_type,
      activity_type: 'post',
      pinned: pinned,
      pinned_action: action,
      posted_at: Time.zone.now,
      time_queued: Time.zone.now.to_time - queued_at.to_time,
      details: 'Posted into newsfeed from queue.'
    )
  end

  def track_clear
    NewsfeedActivity.create(
      trackable_id: publishable_id,
      trackable_type: publishable_type,
      activity_type: 'clear',
      posted_at: posted_at,
      cleared_at: Time.zone.now,
      time_posted: Time.zone.now.to_time - posted_at.to_time,
      details: 'Removed from the newsfeed.'
    )
  end
end
