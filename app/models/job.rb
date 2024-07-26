# frozen_string_literal: true

class Job < ApplicationRecord
  has_many :job_skills

  validtes :name, presence: true
end
