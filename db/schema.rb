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

ActiveRecord::Schema[8.1].define(version: 2026_08_10_031909) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "post_images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "post_id", null: false
    t.string "post_image", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_images_on_post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.string "merchandise"
    t.integer "number_view"
    t.string "schedule"
    t.bigint "shop_id", null: false
    t.boolean "sold_out", default: false, null: false
    t.string "top_merchandise"
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_posts_on_shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "business_hours"
    t.datetime "created_at", null: false
    t.text "kodawari"
    t.decimal "latitude", null: false
    t.integer "like_count"
    t.decimal "longitude", null: false
    t.string "name", null: false
    t.string "price"
    t.string "season"
    t.string "shop_image", null: false
    t.string "timing"
    t.datetime "updated_at", null: false
  end

  create_table "user_post_likes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "post_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["post_id"], name: "index_user_post_likes_on_post_id"
    t.index ["user_id", "post_id"], name: "index_user_post_likes_on_user_id_and_post_id", unique: true
    t.index ["user_id"], name: "index_user_post_likes_on_user_id"
  end

  create_table "user_shop_likes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "shop_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["shop_id"], name: "index_user_shop_likes_on_shop_id"
    t.index ["user_id", "shop_id"], name: "index_user_shop_likes_on_user_id_and_shop_id", unique: true
    t.index ["user_id"], name: "index_user_shop_likes_on_user_id"
  end

  create_table "user_shops", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "shop_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["shop_id"], name: "index_user_shops_on_shop_id"
    t.index ["user_id", "shop_id"], name: "index_user_shops_on_user_id_and_shop_id", unique: true
    t.index ["user_id"], name: "index_user_shops_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "age"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "phone_number", null: false
    t.datetime "updated_at", null: false
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
  end

  add_foreign_key "post_images", "posts"
  add_foreign_key "posts", "shops"
  add_foreign_key "user_post_likes", "posts"
  add_foreign_key "user_post_likes", "users"
  add_foreign_key "user_shop_likes", "shops"
  add_foreign_key "user_shop_likes", "users"
  add_foreign_key "user_shops", "shops"
  add_foreign_key "user_shops", "users"
end
