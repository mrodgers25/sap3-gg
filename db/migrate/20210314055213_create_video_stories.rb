class CreateVideoStories < ActiveRecord::Migration[6.1]
  def change
    create_table :video_stories do |t|
      t.string "video_url"
      t.string "title"
      t.text "description"
      t.text "url_keywords"
      t.text "editor_tagline"
      t.text "hashtags"
      t.string "video_creator"
      t.integer "story_month"
      t.integer "story_date"
      t.integer "story_year"
      t.string "channel_id"
      t.integer "video_duration"
      t.text "video_hashtags"
      t.boolean "outside_usa"
      t.string "state", default: "draft"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
