class AddPubdateToStory < ActiveRecord::Migration
  def change
    add_column :stories, :sap_publish_date, :date
  end
end
