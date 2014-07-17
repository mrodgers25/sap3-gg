class CreateMediaInfos < ActiveRecord::Migration
  def change
    create_table :media_infos do |t|
      t.string :media_type
      t.string :url_id
      t.string :media_desc

      t.timestamps
    end
  end
end
