class RemoveUrl2FromUrl < ActiveRecord::Migration[6.0]
  def change
    remove_column :urls, :url, :string
  end
end
