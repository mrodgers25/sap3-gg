class RemovePrimaryFromUrls < ActiveRecord::Migration
  def change
    remove_column :urls, :primary, :string
  end
end
