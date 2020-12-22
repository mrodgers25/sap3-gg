class CreateStories < ActiveRecord::Migration[6.0]
  def change
    create_table :stories do |t|
      t.string :url_id
      t.string :media_id
      t.string :story_type
      t.string :author
      t.date :publication_date

      t.timestamps
    end
  end
end
