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

ActiveRecord::Schema.define(version: 2023_01_14_004336) do

  create_table "active_storage_attachments", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb3", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "administrators", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_administrators_on_email", unique: true
    t.index ["reset_password_token"], name: "index_administrators_on_reset_password_token", unique: true
  end

  create_table "bedtypes", charset: "utf8mb3", force: :cascade do |t|
    t.string "bed_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cities", charset: "utf8mb3", force: :cascade do |t|
    t.string "city_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "prefecture_id", null: false
    t.index ["prefecture_id"], name: "index_cities_on_prefecture_id"
  end

  create_table "comments", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "uaccount_id"
    t.bigint "oaccount_id"
    t.integer "sender_flg", null: false
    t.bigint "reserve_date_id", null: false
    t.datetime "uaccount_read_at"
    t.datetime "oaccount_read_at"
    t.datetime "deleted_at"
    t.text "comment", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["oaccount_id"], name: "index_comments_on_oaccount_id"
    t.index ["reserve_date_id"], name: "index_comments_on_reserve_date_id"
    t.index ["uaccount_id"], name: "index_comments_on_uaccount_id"
  end

  create_table "favorites", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "uaccount_id", null: false
    t.bigint "oaccount_id", null: false
    t.integer "favorite_flg", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["oaccount_id"], name: "index_favorites_on_oaccount_id"
    t.index ["uaccount_id"], name: "index_favorites_on_uaccount_id"
  end

  create_table "matters", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "uaccount_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.text "remark"
    t.string "end_reception_flg"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uaccount_id"], name: "index_matters_on_uaccount_id"
  end

  create_table "oaccount_notices", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "oaccount_id", null: false
    t.datetime "begin_at", null: false
    t.datetime "end_at"
    t.text "notice_text", null: false
    t.datetime "checked_at"
    t.string "link_to"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["oaccount_id"], name: "index_oaccount_notices_on_oaccount_id"
  end

  create_table "oaccounts", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "office_name"
    t.integer "office_city_id"
    t.string "office_url"
    t.integer "office_bed_count"
    t.text "office_apear"
    t.string "office_image"
    t.integer "office_bed_type"
    t.string "office_phone", null: false
    t.date "startday"
    t.string "address"
    t.string "trance_area"
    t.string "medical_practice"
    t.integer "display_sort"
    t.integer "display_sw"
    t.integer "max_reservation_months", default: 3, null: false
    t.integer "paid_oaccount", default: 0, null: false
    t.string "office_num"
    t.string "fax_num"
    t.integer "bed_type2_id"
    t.index ["confirmation_token"], name: "index_oaccounts_on_confirmation_token", unique: true
    t.index ["email"], name: "index_oaccounts_on_email", unique: true
    t.index ["reset_password_token"], name: "index_oaccounts_on_reset_password_token", unique: true
  end

  create_table "offices", charset: "utf8mb3", force: :cascade do |t|
    t.integer "office_id"
    t.string "office_name"
    t.integer "office_prefecture_id"
    t.integer "office_city_id"
    t.string "office_url"
    t.integer "office_bed_count"
    t.string "office_email"
    t.text "office_apear"
    t.string "office_image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password"
  end

  create_table "pasts", charset: "utf8mb3", force: :cascade do |t|
    t.string "past_use"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "prefectures", charset: "utf8mb3", force: :cascade do |t|
    t.string "prefecture"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reserve_counts", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "oaccount_id"
    t.date "date", null: false
    t.integer "last_count", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "disable_bed_count", default: 0, null: false
    t.index ["oaccount_id", "date"], name: "index_reserve_counts_on_oaccount_id_and_date", unique: true
    t.index ["oaccount_id"], name: "index_reserve_counts_on_oaccount_id"
  end

  create_table "reserve_dates", charset: "utf8mb3", force: :cascade do |t|
    t.integer "office_id"
    t.date "start_date"
    t.date "end_date"
    t.integer "entry_flg"
    t.text "remark"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "start_transfer_id"
    t.integer "end_transfer_id"
    t.integer "past_use_id"
    t.integer "user_id"
    t.string "reserve_code", null: false
    t.string "user_name"
    t.string "user_phone"
    t.string "client_name"
    t.index ["reserve_code"], name: "index_reserve_dates_on_reserve_code", unique: true
  end

  create_table "transfers", charset: "utf8mb3", force: :cascade do |t|
    t.string "trans_flg"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "uaccount_notices", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "uaccount_id", null: false
    t.datetime "begin_at", null: false
    t.datetime "end_at"
    t.text "notice_text", null: false
    t.datetime "checked_at"
    t.string "link_to"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uaccount_id"], name: "index_uaccount_notices_on_uaccount_id"
  end

  create_table "uaccounts", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_name"
    t.string "user_office"
    t.string "user_phone"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "commerce"
    t.index ["email"], name: "index_uaccounts_on_email", unique: true
    t.index ["reset_password_token"], name: "index_uaccounts_on_reset_password_token", unique: true
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "user_email"
    t.string "user_name"
    t.string "user_office"
    t.string "user_phone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.string "password"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cities", "prefectures"
  add_foreign_key "favorites", "oaccounts"
  add_foreign_key "favorites", "uaccounts"
  add_foreign_key "matters", "uaccounts"
  add_foreign_key "oaccount_notices", "oaccounts"
  add_foreign_key "uaccount_notices", "uaccounts"
end
