class RemoveUrl2FromUrl < ActiveRecord::Migration
  def change
    remove_column :urls, :url, :string
  end
end
