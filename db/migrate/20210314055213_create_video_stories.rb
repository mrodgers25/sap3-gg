class CreateVideoStories < ActiveRecord::Migration[6.1]
  def change
    create_table :video_stories do |t|
      t.string "story_type", limit: 255
      t.string "author", limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer "story_month"
      t.integer "story_date"
      t.integer "story_year"
      t.string "title"
      t.text "description"
      t.string "video_url"
      t.boolean "outside_usa"
      t.string "state", default: "draft"
    end
  end
end
