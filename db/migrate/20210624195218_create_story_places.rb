class CreateStoryPlaces < ActiveRecord::Migration[6.1]
  def change
    create_table :story_places do |t|
      t.references :story, null: false, foreign_key: true
      t.references :place, null: false, foreign_key: true

      t.timestamps
    end
  end
end
