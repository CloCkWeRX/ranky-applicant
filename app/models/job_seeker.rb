# frozen_string_literal: true

# An individual (https://schema.org/Person) seeking potential employment.
#
# Has one or more "skills"
class JobSeeker < ApplicationRecord
  has_many :job_seeker_skills, dependent: :destroy

  validates :name, presence: true
end
