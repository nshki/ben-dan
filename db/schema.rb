# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_26_165838) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friends", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "friend_id"
    t.boolean "confirmed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmed"], name: "index_friends_on_confirmed"
    t.index ["friend_id", "user_id"], name: "index_friends_on_friend_id_and_user_id", unique: true
    t.index ["user_id", "friend_id"], name: "index_friends_on_user_id_and_friend_id", unique: true
  end

  create_table "game_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "game_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "hand", default: [], array: true
    t.integer "score", default: 0
  end

  create_table "games", force: :cascade do |t|
    t.jsonb "board"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "current_turn_user_id"
    t.string "tile_bag", default: [], array: true
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "words", force: :cascade do |t|
    t.string "spelling"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["spelling"], name: "index_words_on_spelling"
  end

end
