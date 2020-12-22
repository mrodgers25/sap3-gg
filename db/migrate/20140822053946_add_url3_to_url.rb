class AddUrl3ToUrl < ActiveRecord::Migration[6.0]
  def change
    add_column :urls, :url_full, :string
  end
end
