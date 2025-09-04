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

ActiveRecord::Schema[8.0].define(version: 2025_09_04_053958) do
  create_table "domains", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.integer "position", null: false
    t.decimal "weight", precision: 5, scale: 4, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_domains_on_name", unique: true
    t.index ["position"], name: "index_domains_on_position", unique: true
  end

  create_table "lessons", force: :cascade do |t|
    t.integer "domain_id", null: false
    t.string "title", null: false
    t.text "content", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "summary"
    t.index ["domain_id", "position"], name: "index_lessons_on_domain_id_and_position", unique: true
    t.index ["domain_id"], name: "index_lessons_on_domain_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "lesson_id", null: false
    t.string "question_type", null: false
    t.text "content", null: false
    t.string "correct_answer", null: false
    t.text "options"
    t.text "explanation"
    t.integer "experience_points", default: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_questions_on_lesson_id"
  end

  create_table "user_answers", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "question_id", null: false
    t.string "selected_answer", null: false
    t.boolean "correct", default: false
    t.datetime "answered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_user_answers_on_question_id"
    t.index ["user_id", "question_id"], name: "index_user_answers_on_user_id_and_question_id", unique: true
    t.index ["user_id"], name: "index_user_answers_on_user_id"
  end

  create_table "user_progresses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "lesson_id", null: false
    t.datetime "completed_at"
    t.integer "score"
    t.integer "attempts", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_user_progresses_on_lesson_id"
    t.index ["user_id", "lesson_id"], name: "index_user_progresses_on_user_id_and_lesson_id", unique: true
    t.index ["user_id"], name: "index_user_progresses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "name", null: false
    t.integer "experience_points", default: 0, null: false
    t.integer "level", default: 1, null: false
    t.integer "current_streak", default: 0, null: false
    t.date "last_activity_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "lessons", "domains"
  add_foreign_key "questions", "lessons"
  add_foreign_key "user_answers", "questions"
  add_foreign_key "user_answers", "users"
  add_foreign_key "user_progresses", "lessons"
  add_foreign_key "user_progresses", "users"
end
