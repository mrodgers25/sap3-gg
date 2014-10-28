class AddDataentrydurationToStory < ActiveRecord::Migration
  def change
    add_column :stories, :data_entry_time, :time
  end
end
