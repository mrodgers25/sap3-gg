# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170716205915) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ahoy_events", id: :uuid, force: :cascade do |t|
    t.uuid     "visit_id"
    t.integer  "user_id"
    t.string   "name",       limit: 255
    t.json     "properties"
    t.datetime "time"
  end

  add_index "ahoy_events", ["time"], name: "index_ahoy_events_on_time", using: :btree
  add_index "ahoy_events", ["user_id"], name: "index_ahoy_events_on_user_id", using: :btree
  add_index "ahoy_events", ["visit_id"], name: "index_ahoy_events_on_visit_id", using: :btree

  create_table "codes", force: :cascade do |t|
    t.string   "code_type",  limit: 255
    t.string   "code_key",   limit: 255
    t.string   "code_value", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "images", force: :cascade do |t|
    t.text     "src_url"
    t.text     "alt_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "url_id"
    t.integer  "image_width"
    t.integer  "image_height"
    t.boolean  "manual_enter"
  end

  add_index "images", ["url_id"], name: "index_images_on_url_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "code",       limit: 255, null: false
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["code"], name: "index_locations_on_code", unique: true, using: :btree

  create_table "mediaowners", force: :cascade do |t|
    t.string   "title",                   limit: 255
    t.string   "url_full",                limit: 255
    t.string   "url_domain",              limit: 255
    t.string   "owner_name",              limit: 255
    t.string   "media_type",              limit: 255
    t.string   "distribution_type",       limit: 255
    t.string   "publication_name",        limit: 255
    t.boolean  "paywall_yn"
    t.string   "content_frequency_time",  limit: 255
    t.string   "content_frequency_other", limit: 255
    t.string   "content_frequency_guide", limit: 255
    t.boolean  "nextissue_yn"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mediaowners", ["url_domain"], name: "index_mediaowners_on_url_domain", unique: true, using: :btree

  create_table "outbound_clicks", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "url",        limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "place_categories", force: :cascade do |t|
    t.string   "code",       limit: 255, null: false
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "place_categories", ["code"], name: "index_place_categories_on_code", unique: true, using: :btree

  create_table "stories", force: :cascade do |t|
    t.string   "story_type",        limit: 255
    t.string   "author",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "story_month"
    t.integer  "story_date"
    t.integer  "story_year"
    t.text     "editor_tagline"
    t.boolean  "author_track"
    t.boolean  "story_year_track"
    t.boolean  "story_month_track"
    t.boolean  "story_date_track"
    t.string   "scraped_type",      limit: 255
    t.datetime "sap_publish_date"
    t.integer  "data_entry_time"
    t.string   "data_entry_user",   limit: 255
    t.integer  "mediaowner_id"
    t.boolean  "story_complete"
    t.integer  "release_seq"
    t.boolean  "outside_usa"
    t.string   "random_field"
    t.string   "permalink"
  end

  add_index "stories", ["sap_publish_date"], name: "index_stories_on_sap_publish_date", using: :btree

  create_table "story_categories", force: :cascade do |t|
    t.string   "code",       limit: 255, null: false
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "story_categories", ["code"], name: "index_story_categories_on_code", unique: true, using: :btree

  create_table "story_locations", force: :cascade do |t|
    t.integer  "story_id",    null: false
    t.integer  "location_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "story_locations", ["story_id", "location_id"], name: "index_story_locations_on_story_id_and_location_id", unique: true, using: :btree

  create_table "story_place_categories", force: :cascade do |t|
    t.integer  "story_id",          null: false
    t.integer  "place_category_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "story_place_categories", ["story_id", "place_category_id"], name: "index_story_place_categories_on_story_id_and_place_category_id", unique: true, using: :btree

  create_table "story_story_categories", force: :cascade do |t|
    t.integer  "story_id",          null: false
    t.integer  "story_category_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "story_story_categories", ["story_id", "story_category_id"], name: "index_story_story_categories_on_story_id_and_story_category_id", unique: true, using: :btree

  create_table "urls", force: :cascade do |t|
    t.string   "url_type",           limit: 255
    t.string   "url_title",          limit: 255
    t.text     "url_desc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "url_keywords"
    t.integer  "story_id"
    t.string   "url_domain",         limit: 255
    t.string   "url_full",           limit: 255
    t.boolean  "url_title_track"
    t.boolean  "url_desc_track"
    t.boolean  "url_keywords_track"
  end

  add_index "urls", ["story_id"], name: "index_urls_on_story_id", using: :btree
  add_index "urls", ["url_full"], name: "index_urls_on_url_full", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255
    t.integer  "role"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "city_preference",        limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "usersavedstories", force: :cascade do |t|
    t.integer  "story_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "usersavedstories", ["user_id", "story_id"], name: "index_usersavedstories_on_user_id_and_story_id", unique: true, using: :btree

  create_table "visits", id: :uuid, force: :cascade do |t|
    t.uuid     "visitor_id"
    t.string   "ip",               limit: 255
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain", limit: 255
    t.string   "search_keyword",   limit: 255
    t.string   "browser",          limit: 255
    t.string   "os",               limit: 255
    t.string   "device_type",      limit: 255
    t.string   "country",          limit: 255
    t.string   "region",           limit: 255
    t.string   "city",             limit: 255
    t.string   "utm_source",       limit: 255
    t.string   "utm_medium",       limit: 255
    t.string   "utm_term",         limit: 255
    t.string   "utm_content",      limit: 255
    t.string   "utm_campaign",     limit: 255
    t.datetime "started_at"
  end

  add_index "visits", ["user_id"], name: "index_visits_on_user_id", using: :btree

end
