class AddDataentrytimetoStory < ActiveRecord::Migration
  def change
    add_column :stories, :data_entry_time, :integer
  end
end
