class ChangeSapdateInStory < ActiveRecord::Migration
  def change
    change_column :stories, :sap_publish_date, :datetime
  end
end