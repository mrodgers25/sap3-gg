# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_25_142800) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.string "street_address"
    t.string "post_office_box_number"
    t.string "locality"
    t.string "region"
    t.string "postal_code"
    t.string "country"
    t.string "custom_1"
    t.string "custom_2"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "admin_settings", force: :cascade do |t|
    t.integer "newsfeed_display_limit", default: 75
    t.integer "filtered_display_limit", default: 36
    t.integer "newsfeed_daily_post_count", default: 10
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "codes", force: :cascade do |t|
    t.string "code_type"
    t.string "code_key"
    t.string "code_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "reference"
    t.integer "reference_id"
    t.text "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "images", force: :cascade do |t|
    t.text "src_url"
    t.text "alt_text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "url_id"
    t.integer "image_width"
    t.integer "image_height"
    t.boolean "manual_enter"
    t.index ["url_id"], name: "index_images_on_url_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_locations_on_code", unique: true
  end

  create_table "media_owners", force: :cascade do |t|
    t.string "title"
    t.string "url_domain"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["url_domain"], name: "index_media_owners_on_url_domain", unique: true
  end

  create_table "newsfeed_activities", force: :cascade do |t|
    t.integer "trackable_id"
    t.string "trackable_type"
    t.string "activity_type"
    t.datetime "posted_at"
    t.datetime "cleared_at"
    t.boolean "pinned"
    t.string "pinned_action"
    t.float "time_posted"
    t.float "time_pinned"
    t.float "time_queued"
    t.string "details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_type"], name: "index_newsfeed_activities_on_activity_type"
    t.index ["trackable_type", "trackable_id"], name: "index_newsfeed_activities_on_trackable_type_and_trackable_id"
  end

  create_table "outbound_clicks", force: :cascade do |t|
    t.integer "user_id"
    t.string "url", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "place_categories", force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_place_categories_on_code", unique: true
  end

  create_table "place_status_options", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "places", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "address_id", null: false
    t.bigint "place_status_option_id", null: false
    t.integer "imported_place_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["address_id"], name: "index_places_on_address_id"
    t.index ["place_status_option_id"], name: "index_places_on_place_status_option_id"
  end

  create_table "published_items", force: :cascade do |t|
    t.integer "publishable_id"
    t.string "publishable_type"
    t.datetime "displayed_at"
    t.datetime "clear_at"
    t.boolean "pinned", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "state"
    t.integer "queue_position"
    t.datetime "queued_at"
    t.datetime "posted_at"
    t.string "pinned_action", default: "release"
    t.index ["pinned"], name: "index_published_items_on_pinned"
    t.index ["posted_at"], name: "index_published_items_on_posted_at"
    t.index ["publishable_type", "publishable_id"], name: "index_published_items_on_publishable_type_and_publishable_id"
    t.index ["queue_position"], name: "index_published_items_on_queue_position"
    t.index ["queued_at"], name: "index_published_items_on_queued_at"
    t.index ["state"], name: "index_published_items_on_state"
  end

  create_table "stories", force: :cascade do |t|
    t.string "story_type"
    t.string "author"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "story_month"
    t.integer "story_date"
    t.integer "story_year"
    t.text "editor_tagline"
    t.boolean "author_track"
    t.boolean "story_year_track"
    t.boolean "story_month_track"
    t.boolean "story_date_track"
    t.string "scraped_type"
    t.datetime "sap_publish_date"
    t.integer "data_entry_time"
    t.string "data_entry_user"
    t.integer "mediaowner_id"
    t.boolean "story_complete"
    t.integer "release_seq"
    t.boolean "outside_usa"
    t.string "permalink"
    t.string "state", default: "no_status"
    t.integer "desc_length", default: 200
    t.string "type"
    t.text "hashtags"
    t.string "video_creator"
    t.string "video_channel_id"
    t.integer "video_duration", default: 0
    t.text "video_hashtags"
    t.integer "video_views"
    t.integer "video_subscribers"
    t.boolean "video_unlisted", default: false
    t.integer "video_likes", default: 0
    t.integer "video_dislikes", default: 0
    t.index ["sap_publish_date"], name: "index_stories_on_sap_publish_date"
    t.index ["state"], name: "index_stories_on_state"
  end

  create_table "stories_users", force: :cascade do |t|
    t.bigint "story_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, default: -> { "now()" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "now()" }, null: false
    t.index ["story_id"], name: "index_stories_users_on_story_id"
    t.index ["user_id"], name: "index_stories_users_on_user_id"
  end

  create_table "story_activities", force: :cascade do |t|
    t.integer "story_id"
    t.integer "user_id"
    t.string "from"
    t.string "to"
    t.string "event"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "story_categories", force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_story_categories_on_code", unique: true
  end

  create_table "story_locations", force: :cascade do |t|
    t.integer "story_id", null: false
    t.integer "location_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["story_id", "location_id"], name: "index_story_locations_on_story_id_and_location_id", unique: true
  end

  create_table "story_place_categories", force: :cascade do |t|
    t.integer "story_id", null: false
    t.integer "place_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["story_id", "place_category_id"], name: "index_story_place_categories_on_story_id_and_place_category_id", unique: true
  end

  create_table "story_places", force: :cascade do |t|
    t.bigint "story_id", null: false
    t.bigint "place_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["place_id"], name: "index_story_places_on_place_id"
    t.index ["story_id"], name: "index_story_places_on_story_id"
  end

  create_table "story_story_categories", force: :cascade do |t|
    t.integer "story_id", null: false
    t.integer "story_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["story_id", "story_category_id"], name: "index_story_story_categories_on_story_id_and_story_category_id", unique: true
  end

  create_table "urls", force: :cascade do |t|
    t.string "url_type"
    t.string "url_title"
    t.text "url_desc"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "url_keywords"
    t.integer "story_id"
    t.string "url_domain"
    t.string "url_full"
    t.boolean "url_title_track"
    t.boolean "url_desc_track"
    t.boolean "url_keywords_track"
    t.index ["story_id"], name: "index_urls_on_story_id"
    t.index ["url_full"], name: "index_urls_on_url_full", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.integer "role"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "first_name"
    t.string "last_name"
    t.string "city_preference"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "usersavedstories", force: :cascade do |t|
    t.integer "story_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id", "story_id"], name: "index_usersavedstories_on_user_id_and_story_id", unique: true
  end

  create_table "visits", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid "visitor_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.text "landing_page"
    t.integer "user_id"
    t.string "referring_domain"
    t.string "search_keyword"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_visits_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "users"
  add_foreign_key "places", "addresses"
  add_foreign_key "places", "place_status_options"
  add_foreign_key "story_places", "places"
  add_foreign_key "story_places", "stories"
end
