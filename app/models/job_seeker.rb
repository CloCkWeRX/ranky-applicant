class JobSeeker < ApplicationRecord
  has_many :job_seeker_skills

  validates :name, presence: true
end
