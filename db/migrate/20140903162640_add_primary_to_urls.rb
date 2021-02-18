class AddPrimaryToUrls < ActiveRecord::Migration[6.0]
  def change
    add_column :urls, :primary, :boolean
  end
end
