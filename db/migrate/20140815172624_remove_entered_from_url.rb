class RemoveEnteredFromUrl < ActiveRecord::Migration[6.0]
  def change
    remove_column :urls, :url_entered, :datetime
  end
end
