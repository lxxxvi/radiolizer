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

ActiveRecord::Schema.define(version: 20151204090000) do

  create_table "artists", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "parent_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "broadcasts", force: :cascade do |t|
    t.datetime "time"
    t.string   "name",            limit: 255
    t.integer  "station_id",      limit: 4
    t.integer  "song_id",         limit: 4
    t.integer  "initial_song_id", limit: 4
    t.integer  "crawl_id",        limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "broadcasts", ["song_id"], name: "index_broadcasts_on_song_id", using: :btree
  add_index "broadcasts", ["station_id"], name: "index_broadcasts_on_station_id", using: :btree

  create_table "crawls", force: :cascade do |t|
    t.integer  "station_id",       limit: 4
    t.datetime "reference_time"
    t.string   "load_type",        limit: 255
    t.integer  "found_broadcasts", limit: 4,   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "crawls", ["station_id"], name: "index_crawls_on_station_id", using: :btree

  create_table "songs", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.integer  "parent_id",         limit: 4
    t.integer  "artist_id",         limit: 4
    t.integer  "initial_artist_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "endpoint",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
