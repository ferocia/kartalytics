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

ActiveRecord::Schema[7.2].define(version: 2025_07_07_052014) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entered_matches", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "kartalytics_match_id", null: false
    t.integer "final_position"
    t.integer "final_score"
    t.index ["kartalytics_match_id"], name: "index_entered_matches_on_kartalytics_match_id"
    t.index ["player_id"], name: "index_entered_matches_on_player_id"
  end

  create_table "entered_races", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "race_id", null: false
    t.bigint "course_id", null: false
    t.bigint "kartalytics_match_id", null: false
    t.float "race_time"
    t.integer "final_position"
    t.index ["course_id"], name: "index_entered_races_on_course_id"
    t.index ["kartalytics_match_id"], name: "index_entered_races_on_kartalytics_match_id"
    t.index ["player_id"], name: "index_entered_races_on_player_id"
    t.index ["race_id"], name: "index_entered_races_on_race_id"
  end

  create_table "kartalytics_courses", force: :cascade do |t|
    t.string "name", null: false
    t.float "world_record_time", default: 0.0, null: false
  end

  create_table "kartalytics_matches", force: :cascade do |t|
    t.bigint "match_id"
    t.string "status", default: "in_progress", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "player_one_score", default: 0
    t.integer "player_two_score", default: 0
    t.integer "player_three_score", default: 0
    t.integer "player_four_score", default: 0
    t.integer "player_one_position"
    t.integer "player_two_position"
    t.integer "player_three_position"
    t.integer "player_four_position"
    t.integer "player_one_id"
    t.integer "player_two_id"
    t.integer "player_three_id"
    t.integer "player_four_id"
    t.integer "player_count"
    t.integer "player_one_order", default: 0
    t.integer "player_two_order", default: 0
    t.integer "player_three_order", default: 0
    t.integer "player_four_order", default: 0
    t.index ["match_id"], name: "index_kartalytics_matches_on_match_id"
    t.index ["player_four_id"], name: "index_kartalytics_matches_on_player_four_id"
    t.index ["player_one_id"], name: "index_kartalytics_matches_on_player_one_id"
    t.index ["player_three_id"], name: "index_kartalytics_matches_on_player_three_id"
    t.index ["player_two_id"], name: "index_kartalytics_matches_on_player_two_id"
  end

  create_table "kartalytics_race_snapshots", force: :cascade do |t|
    t.bigint "kartalytics_race_id", null: false
    t.datetime "timestamp", precision: nil, null: false
    t.integer "player_one_position"
    t.integer "player_two_position"
    t.integer "player_three_position"
    t.integer "player_four_position"
    t.string "player_one_item"
    t.string "player_two_item"
    t.string "player_three_item"
    t.string "player_four_item"
    t.index ["kartalytics_race_id"], name: "index_kartalytics_race_snapshots_on_kartalytics_race_id"
  end

  create_table "kartalytics_races", force: :cascade do |t|
    t.string "status", default: "in_progress", null: false
    t.bigint "kartalytics_course_id", null: false
    t.bigint "kartalytics_match_id", null: false
    t.datetime "started_at", precision: nil
    t.datetime "finished_at", precision: nil
    t.integer "player_one_position"
    t.integer "player_two_position"
    t.integer "player_three_position"
    t.integer "player_four_position"
    t.datetime "player_one_finished_at", precision: nil
    t.datetime "player_two_finished_at", precision: nil
    t.datetime "player_three_finished_at", precision: nil
    t.datetime "player_four_finished_at", precision: nil
    t.integer "player_one_score"
    t.integer "player_two_score"
    t.integer "player_three_score"
    t.integer "player_four_score"
    t.json "detected_courses", default: {}, null: false
    t.binary "detected_image"
    t.index ["kartalytics_course_id"], name: "index_kartalytics_races_on_kartalytics_course_id"
    t.index ["kartalytics_match_id"], name: "index_kartalytics_races_on_kartalytics_match_id"
  end

  create_table "kartalytics_state", force: :cascade do |t|
    t.integer "current_match_id"
    t.integer "current_race_id"
    t.json "last_event"
    t.index ["current_match_id"], name: "index_kartalytics_state_on_current_match_id"
    t.index ["current_race_id"], name: "index_kartalytics_state_on_current_race_id"
  end

  create_table "leagues", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matches", force: :cascade do |t|
    t.text "players_in_order", null: false
    t.string "league_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["league_id"], name: "index_matches_on_league_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "slack_id"
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "retired"
    t.index ["slack_id"], name: "index_players_on_slack_id"
  end

  add_foreign_key "entered_matches", "kartalytics_matches"
  add_foreign_key "entered_matches", "players"
  add_foreign_key "entered_races", "kartalytics_courses", column: "course_id"
  add_foreign_key "entered_races", "kartalytics_matches"
  add_foreign_key "entered_races", "kartalytics_races", column: "race_id"
  add_foreign_key "entered_races", "players"
  add_foreign_key "kartalytics_matches", "matches"
  add_foreign_key "kartalytics_matches", "players", column: "player_four_id"
  add_foreign_key "kartalytics_matches", "players", column: "player_one_id"
  add_foreign_key "kartalytics_matches", "players", column: "player_three_id"
  add_foreign_key "kartalytics_matches", "players", column: "player_two_id"
  add_foreign_key "kartalytics_race_snapshots", "kartalytics_races"
  add_foreign_key "kartalytics_races", "kartalytics_courses"
  add_foreign_key "kartalytics_races", "kartalytics_matches"
  add_foreign_key "kartalytics_state", "kartalytics_matches", column: "current_match_id"
  add_foreign_key "kartalytics_state", "kartalytics_races", column: "current_race_id"
  add_foreign_key "matches", "leagues"
end
