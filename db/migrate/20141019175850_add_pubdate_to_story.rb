class AddPubdateToStory < ActiveRecord::Migration[6.0]
  def change
    add_column :stories, :sap_publish_date, :date
  end
end
