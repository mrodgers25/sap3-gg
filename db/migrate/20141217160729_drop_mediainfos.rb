class DropMediainfos < ActiveRecord::Migration
  def change
    drop_table :media_infos
  end
end
