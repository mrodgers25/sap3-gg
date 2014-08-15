class RemoveEnteredFromUrl < ActiveRecord::Migration
  def change
    remove_column :urls, :url_entered, :datetime
  end
end
