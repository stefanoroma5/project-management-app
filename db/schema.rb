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

ActiveRecord::Schema[7.0].define(version: 2024_01_23_133643) do
  create_table "developer_projects", force: :cascade do |t|
    t.integer "developer_id", null: false
    t.integer "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["developer_id"], name: "index_developer_projects_on_developer_id"
    t.index ["project_id"], name: "index_developer_projects_on_project_id"
  end

  create_table "developers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "lastname"
    t.index ["email"], name: "index_developers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_developers_on_reset_password_token", unique: true
  end

  create_table "developers_tasks", id: false, force: :cascade do |t|
    t.integer "developer_id", null: false
    t.integer "task_id", null: false
    t.index ["developer_id", "task_id"], name: "index_developers_tasks_on_developer_id_and_task_id"
    t.index ["task_id", "developer_id"], name: "index_developers_tasks_on_task_id_and_developer_id"
  end

  create_table "labels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "labels_tasks", id: false, force: :cascade do |t|
    t.integer "label_id", null: false
    t.integer "task_id", null: false
    t.index ["label_id", "task_id"], name: "index_labels_tasks_on_label_id_and_task_id"
    t.index ["task_id", "label_id"], name: "index_labels_tasks_on_task_id_and_label_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.date "deadline"
    t.string "customer"
    t.string "description"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.integer "developer_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.string "status"
    t.string "description"
    t.string "task_type"
    t.integer "estimation"
    t.string "priority"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "developer_projects", "developers"
  add_foreign_key "developer_projects", "projects"
end
