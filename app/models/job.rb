# frozen_string_literal: true

# A job is a regular activity performed in exchange for payment, or a task or project that may or may not be compensated.
# See https://en.wikipedia.org/wiki/Work_(human_activity)
#
# In this modelling, a "job" requires one or more skills.
#
# Loosely, this is the same logical model as https://www.abs.gov.au/statistics/classifications/anzsco-australian-and-new-zealand-standard-classification-occupations/latest-release
# or https://schema.org/JobPosting
class Job < ApplicationRecord
  has_many :job_skills, dependent: :destroy, counter_cache: :job_skills_count

  validates :name, presence: true
end
