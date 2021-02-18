class CreateMediaInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :media_infos do |t|
      t.string :media_type
      t.string :url_id
      t.string :media_desc

      t.timestamps
    end
  end
end
