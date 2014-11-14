class AddDataEntryToStory < ActiveRecord::Migration
  def change
    add_column :stories, :data_entry_user, :string
  end
end
