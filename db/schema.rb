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

ActiveRecord::Schema.define(version: 2020_02_29_163629) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "project_step_confidences", force: :cascade do |t|
    t.bigint "project_step_id", null: false
    t.string "confidence", null: false
    t.string "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_step_id"], name: "index_project_step_confidences_on_project_step_id"
  end

  create_table "project_step_health_metrics", force: :cascade do |t|
    t.bigint "project_step_id", null: false
    t.string "health", null: false
    t.string "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_step_id"], name: "index_project_step_health_metrics_on_project_step_id"
  end

  create_table "project_step_next_projects", force: :cascade do |t|
    t.bigint "project_step_id", null: false
    t.string "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_step_id"], name: "index_project_step_next_projects_on_project_step_id"
  end

  create_table "project_step_priorities", force: :cascade do |t|
    t.bigint "project_step_id", null: false
    t.string "priority", null: false
    t.string "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_step_id"], name: "index_project_step_priorities_on_project_step_id"
  end

  create_table "project_steps", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.integer "year"
    t.string "quarter"
    t.date "start_at"
    t.date "end_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_project_steps_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "project_step_confidences", "project_steps"
  add_foreign_key "project_step_health_metrics", "project_steps"
  add_foreign_key "project_step_next_projects", "project_steps"
  add_foreign_key "project_step_priorities", "project_steps"
  add_foreign_key "project_steps", "projects"
end
