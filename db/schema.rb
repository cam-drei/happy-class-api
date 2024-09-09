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

ActiveRecord::Schema[7.1].define(version: 2024_05_22_034028) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contents", force: :cascade do |t|
    t.string "video_link"
    t.string "document_link"
    t.string "resource_type"
    t.integer "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enroll_courses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_enroll_courses_on_course_id"
    t.index ["user_id", "course_id"], name: "index_enroll_courses_on_user_id_and_course_id", unique: true
    t.index ["user_id"], name: "index_enroll_courses_on_user_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_lessons_on_course_id"
  end

  create_table "subject_lessons", force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.bigint "lesson_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "done", default: false #remove later
    t.index ["lesson_id"], name: "index_subject_lessons_on_lesson_id"
    t.index ["subject_id", "lesson_id"], name: "index_subject_lessons_on_subject_id_and_lesson_id", unique: true
    t.index ["subject_id"], name: "index_subject_lessons_on_subject_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_subjects_on_course_id"
  end

  create_table "user_lessons", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "lesson_id", null: false
    t.boolean "done", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_user_lessons_on_lesson_id"
    t.index ["user_id", "lesson_id"], name: "index_user_lessons_on_user_id_and_lesson_id", unique: true
    t.index ["user_id"], name: "index_user_lessons_on_user_id"
  end

  create_table "user_subject_lessons", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "subject_lesson_id", null: false
    t.boolean "done", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_lesson_id"], name: "index_user_subject_lessons_on_subject_lesson_id"
    t.index ["user_id", "subject_lesson_id"], name: "index_user_subject_lessons_on_user_id_and_subject_lesson_id", unique: true
    t.index ["user_id"], name: "index_user_subject_lessons_on_user_id"
  end

  create_table "user_subjects", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "subject_id"
    t.boolean "selected", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_user_subjects_on_subject_id"
    t.index ["user_id", "subject_id"], name: "index_user_subjects_on_user_id_and_subject_id", unique: true
    t.index ["user_id"], name: "index_user_subjects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "authentication_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "enroll_courses", "courses"
  add_foreign_key "enroll_courses", "users"
  add_foreign_key "lessons", "courses"
  add_foreign_key "subject_lessons", "lessons"
  add_foreign_key "subject_lessons", "subjects"
  add_foreign_key "subjects", "courses"
  add_foreign_key "user_lessons", "lessons"
  add_foreign_key "user_lessons", "users"
  add_foreign_key "user_subject_lessons", "subject_lessons"
  add_foreign_key "user_subject_lessons", "users"
  add_foreign_key "user_subjects", "subjects"
  add_foreign_key "user_subjects", "users"
end
