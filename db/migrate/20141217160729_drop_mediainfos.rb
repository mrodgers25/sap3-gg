class DropMediainfos < ActiveRecord::Migration[6.0]
  def change
    drop_table :media_infos
  end
end
