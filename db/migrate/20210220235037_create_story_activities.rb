class CreateStoryActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :story_activities do |t|
      t.integer :story_id
      t.integer :user_id
      t.string  :from
      t.string  :to
      t.string  :event

      t.timestamps
    end
  end
end
