class AddIndexToStories < ActiveRecord::Migration
  def change
    add_index :stories, :sap_publish_date
  end
end
