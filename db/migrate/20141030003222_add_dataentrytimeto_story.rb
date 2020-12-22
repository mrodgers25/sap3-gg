class AddDataentrytimetoStory < ActiveRecord::Migration[6.0]
  def change
    add_column :stories, :data_entry_time, :integer
  end
end
