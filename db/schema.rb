# frozen_string_literal: true

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

ActiveRecord::Schema[7.1].define(version: 20_240_726_114_426) do
  create_table 'job_seeker_skills', force: :cascade do |t|
    t.integer 'job_seeker_id'
    t.string 'skill', null: false
    t.index ['job_seeker_id'], name: 'index_job_seeker_skills_on_job_seeker_id'
    t.index ['skill'], name: 'index_job_seeker_skills_on_skill'
  end

  create_table 'job_seekers', force: :cascade do |t|
    t.string 'name', null: false
  end

  create_table 'job_skills', force: :cascade do |t|
    t.integer 'job_id'
    t.string 'skill', null: false
    t.index ['job_id'], name: 'index_job_skills_on_job_id'
    t.index ['skill'], name: 'index_job_skills_on_skill'
  end

  create_table 'jobs', force: :cascade do |t|
    t.string 'name', null: false
  end
end
