class AddDataentrydurationToStory < ActiveRecord::Migration[6.0]
  def change
    add_column :stories, :data_entry_time, :time
  end
end
