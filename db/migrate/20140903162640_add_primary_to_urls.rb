class AddPrimaryToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :primary, :boolean
  end
end
