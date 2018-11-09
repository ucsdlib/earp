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

ActiveRecord::Schema.define(version: 2018_11_09_225636) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "employees", force: :cascade do |t|
    t.string "uid", null: false
    t.string "name", null: false
    t.string "manager", null: false
    t.string "email", null: false
    t.string "display_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "opt_out_links", force: :cascade do |t|
    t.string "key", null: false
    t.bigint "recognition_id", null: false
    t.datetime "expires", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recognitions", force: :cascade do |t|
    t.string "library_value", null: false
    t.text "description", null: false
    t.boolean "anonymous", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "employee_id"
    t.boolean "suppressed", default: false
    t.index ["employee_id"], name: "index_recognitions_on_employee_id"
    t.index ["user_id"], name: "index_recognitions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: ""
    t.string "full_name", default: ""
    t.string "uid", default: "", null: false
    t.string "provider", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "recognitions", "employees"
  add_foreign_key "recognitions", "users"
end
