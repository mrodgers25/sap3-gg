class ChangeDataentrydurationInStory < ActiveRecord::Migration[6.0]
  def change
    remove_column :stories, :data_entry_time
  end
end
