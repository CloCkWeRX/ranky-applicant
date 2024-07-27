# frozen_string_literal: true

class AddCounterCaches < ActiveRecord::Migration[7.1]
  def change
    add_column :job_seekers, :job_seeker_skills_count, :int, default: 0
    add_column :jobs, :job_skills_count, :int, default: 0
  end
end
