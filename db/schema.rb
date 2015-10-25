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

ActiveRecord::Schema.define(version: 20151025102213) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assets", force: :cascade do |t|
    t.text     "filename",                  null: false
    t.string   "type",           limit: 30
    t.integer  "assetable_id"
    t.string   "assetable_type"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "assets", ["assetable_type", "assetable_id"], name: "index_assets_on_assetable_type_and_assetable_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.integer  "sort_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "daily_menus", force: :cascade do |t|
    t.integer  "day_number"
    t.float    "max_total"
    t.integer  "dish_ids",   default: [],              array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "daily_rations", force: :cascade do |t|
    t.float    "price"
    t.integer  "quantity"
    t.integer  "daily_menu_id"
    t.integer  "sprint_id"
    t.integer  "dish_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "daily_rations", ["daily_menu_id"], name: "index_daily_rations_on_daily_menu_id", using: :btree
  add_index "daily_rations", ["dish_id"], name: "index_daily_rations_on_dish_id", using: :btree
  add_index "daily_rations", ["sprint_id"], name: "index_daily_rations_on_sprint_id", using: :btree

  create_table "dishes", force: :cascade do |t|
    t.string   "title"
    t.integer  "sort_order"
    t.text     "description"
    t.float    "price"
    t.string   "type"
    t.integer  "children_ids", default: [],              array: true
    t.integer  "category_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "sprints", force: :cascade do |t|
    t.string   "title"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer  "state"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
