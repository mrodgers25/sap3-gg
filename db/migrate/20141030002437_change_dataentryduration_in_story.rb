class ChangeDataentrydurationInStory < ActiveRecord::Migration
  def change
    remove_column :stories, :data_entry_time
  end
end
