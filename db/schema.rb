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

ActiveRecord::Schema.define(version: 20160314033427) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.integer  "school1_id"
    t.integer  "school2_id"
    t.integer  "round",                           null: false
    t.datetime "start_time"
    t.boolean  "is_over",         default: false, null: false
    t.integer  "next_game_id"
    t.integer  "winning_team_id"
    t.integer  "losing_team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leagues", force: :cascade do |t|
    t.string   "name",                           null: false
    t.text     "description"
    t.integer  "commissioner_id"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_draft_pick", default: 1, null: false
  end

  create_table "owner_schools", force: :cascade do |t|
    t.integer  "owner_id",   null: false
    t.integer  "school_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "draft_pick", null: false
    t.integer  "league_id",  null: false
  end

  create_table "owners", force: :cascade do |t|
    t.integer  "user_id",                    null: false
    t.integer  "league_id"
    t.string   "team_name",                  null: false
    t.text     "motto"
    t.integer  "draft_pick"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_paid",   default: false, null: false
  end

  create_table "schools", force: :cascade do |t|
    t.string   "name",                                null: false
    t.string   "mascot"
    t.string   "primary_color",   default: "#000000", null: false
    t.string   "secondary_color", default: "#fff",    null: false
    t.integer  "seed_id",                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seeds", force: :cascade do |t|
    t.integer  "seed_number",                  null: false
    t.string   "region",                       null: false
    t.boolean  "play_in_game", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  null: false
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
