class CreateNewsfeedActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :newsfeed_activities do |t|
      t.integer  :trackable_id
      t.string   :trackable_type
      t.string   :activity_type
      t.datetime :posted_at
      t.datetime :cleared_at
      t.boolean  :pinned
      t.string   :pinned_action
      t.float    :time_posted
      t.float    :time_pinned
      t.float    :time_queued
      t.string   :details

      t.timestamps

      t.index [:trackable_type, :trackable_id]
      t.index :activity_type
    end
  end
end
