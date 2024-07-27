# frozen_string_literal: true

# An individual (https://schema.org/Person) seeking potential employment.
#
# Has one or more "skills"
class JobSeeker < ApplicationRecord
  has_many :job_seeker_skills, dependent: :destroy, counter_cache: :job_seeker_skills_count

  validates :name, presence: true
end
