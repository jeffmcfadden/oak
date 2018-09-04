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

ActiveRecord::Schema.define(version: 2018_08_30_215948) do

  create_table "oak_incoming_webmentions", force: :cascade do |t|
    t.string "source_url"
    t.string "target_url"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oak_indieauth_authentication_requests", force: :cascade do |t|
    t.string "me"
    t.string "client_id"
    t.string "redirect_uri"
    t.string "state"
    t.string "code"
    t.integer "user_id"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oak_indieauth_authorization_requests", force: :cascade do |t|
    t.string "me"
    t.string "client_id"
    t.string "redirect_uri"
    t.string "state"
    t.string "scope"
    t.string "code"
    t.integer "user_id"
    t.boolean "approved", default: false
    t.string "access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oak_outgoing_webmentions", force: :cascade do |t|
    t.string "target_url"
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "post_id"
  end

  create_table "oak_post_assets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oak_posts", force: :cascade do |t|
    t.string "title"
    t.string "body"
    t.datetime "published_at"
    t.boolean "live"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_oak_posts_on_slug", unique: true
  end

end
