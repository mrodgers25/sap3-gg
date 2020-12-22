class AddIndexToStories < ActiveRecord::Migration[6.0]
  def change
    add_index :stories, :sap_publish_date
  end
end
