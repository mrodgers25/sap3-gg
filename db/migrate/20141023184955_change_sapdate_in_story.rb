class ChangeSapdateInStory < ActiveRecord::Migration[6.0]
  def change
    change_column :stories, :sap_publish_date, :datetime
  end
end
