class RenameUrlInMediaowners < ActiveRecord::Migration[6.0]
  def change
    rename_column :mediaowners, :url, :url_full
  end
end
