class AddDataEntryToStory < ActiveRecord::Migration[6.0]
  def change
    add_column :stories, :data_entry_user, :string
  end
end
