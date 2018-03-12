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

ActiveRecord::Schema.define(version: 20180312000120) do

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
    t.integer  "school1_score"
    t.integer  "school2_score"
    t.index ["school1_id"], name: "index_games_on_school1_id", using: :btree
    t.index ["school2_id"], name: "index_games_on_school2_id", using: :btree
  end

  create_table "leagues", force: :cascade do |t|
    t.string   "name",                           null: false
    t.text     "description"
    t.integer  "commissioner_id"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_draft_pick", default: 1, null: false
    t.integer  "year"
  end

  create_table "owner_schools", force: :cascade do |t|
    t.integer  "owner_id",   null: false
    t.integer  "school_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "draft_pick", null: false
    t.integer  "league_id",  null: false
    t.index ["owner_id"], name: "index_owner_schools_on_owner_id", using: :btree
    t.index ["school_id", "league_id"], name: "index_owner_schools_on_school_id_and_league_id", using: :btree
    t.index ["school_id", "owner_id"], name: "index_owner_schools_on_school_id_and_owner_id", using: :btree
    t.index ["school_id"], name: "index_owner_schools_on_school_id", using: :btree
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
    t.integer  "year"
    t.string   "slug"
    t.index ["slug"], name: "index_schools_on_slug", using: :btree
  end

  create_table "seeds", force: :cascade do |t|
    t.integer  "seed_number",                  null: false
    t.string   "region",                       null: false
    t.boolean  "play_in_game", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                  null: false
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
    t.boolean  "is_admin",               default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
