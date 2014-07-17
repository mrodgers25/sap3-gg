class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :url
      t.datetime :url_entered
      t.string :url_type
      t.string :url_title
      t.string :url_desc

      t.timestamps
    end
  end
end
