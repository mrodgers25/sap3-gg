class RenameUrlInMediaowners < ActiveRecord::Migration
  def change
    rename_column :mediaowners, :url, :url_full
  end
end
