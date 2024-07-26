# frozen_string_literal: true

class AddInitialSchema < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs do |t|
      t.string :name, null: false
    end
    create_table :job_skills do |t|
      t.references :job
      t.string :skill, null: false

      t.index :skill
    end

    create_table :job_seekers do |t|
      t.string :name
    end

    create_table :job_seeker_skills do |t|
      t.references :job_seeker
      t.string :skill

      t.index :skill
    end
  end
end
