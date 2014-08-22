class AddUrl3ToUrl < ActiveRecord::Migration
  def change
    add_column :urls, :url_full, :string
  end
end
