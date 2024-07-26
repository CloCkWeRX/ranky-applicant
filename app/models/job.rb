# frozen_string_literal: true

class Job < ApplicationRecord
  has_many :job_skills

  validates :name, presence: true
end
