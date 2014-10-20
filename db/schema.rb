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

ActiveRecord::Schema.define(version: 20141019175850) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "images", force: true do |t|
    t.text     "src_url"
    t.text     "alt_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "url_id"
    t.integer  "image_width"
    t.integer  "image_height"
  end

  add_index "images", ["url_id"], name: "index_images_on_url_id", using: :btree

  create_table "media_infos", force: true do |t|
    t.string   "media_type"
    t.string   "url_id"
    t.string   "media_desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stories", force: true do |t|
    t.string   "media_id"
    t.string   "story_type"
    t.string   "author"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "story_month"
    t.integer  "story_date"
    t.integer  "story_year"
    t.text     "editor_tagline"
    t.text     "location_code"
    t.string   "place_category"
    t.boolean  "author_track"
    t.boolean  "story_year_track"
    t.boolean  "story_month_track"
    t.boolean  "story_date_track"
    t.string   "scraped_type"
    t.string   "story_category"
    t.date     "sap_publish_date"
  end

  create_table "urls", force: true do |t|
    t.string   "url_type"
    t.string   "url_title"
    t.text     "url_desc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "url_keywords"
    t.string   "story_id"
    t.string   "url_domain"
    t.string   "url_full"
    t.boolean  "url_title_track"
    t.boolean  "url_desc_track"
    t.boolean  "url_keywords_track"
  end

  add_index "urls", ["story_id"], name: "index_urls_on_story_id", using: :btree
  add_index "urls", ["url_full"], name: "index_urls_on_url_full", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
