class RemovePrimaryFromUrls < ActiveRecord::Migration[6.0]
  def change
    remove_column :urls, :primary, :string
  end
end
