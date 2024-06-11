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

ActiveRecord::Schema[7.0].define(version: 2024_06_10_023304) do
  create_table "favorite_news", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "news_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["news_id"], name: "index_favorite_news_on_news_id"
    t.index ["user_id"], name: "index_favorite_news_on_user_id"
  end

  create_table "news", charset: "utf8", force: :cascade do |t|
    t.string "author_name", null: false
    t.string "title", null: false
    t.text "content", null: false
    t.integer "category_id", null: false
    t.integer "prefecture_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "username"
    t.integer "address_id"
    t.integer "favorite_article_id"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ip_address"], name: "index_users_on_ip_address", unique: true
  end

  add_foreign_key "favorite_news", "news"
  add_foreign_key "favorite_news", "users"
end
