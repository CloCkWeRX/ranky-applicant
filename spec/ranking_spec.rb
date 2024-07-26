# frozen_string_literal: true

require './spec/rails_helper'

describe 'Application Output' do
  describe 'csv rendering' do
    context 'with the exact sample data' do
      let(:jobs_data) do
        CSV.read('./spec/test_data/jobs.csv', headers: true)
      end
      let(:job_seekers_data) do
        CSV.read('./spec/test_data/job_seekers.csv', headers: true)
      end
      before do
        jobs_data.each do |row|
          job = Job.new(name: row[:title])
          
          puts row[:required_skills].inspect
        end
        # create(:job, name: 'Ruby Developer', job_skills: [])
        # create(:job, name: '.NET Developer')
        # create(:job, name: 'C# Developer')
        # create(:job, name: 'Dev Ops Engineer')
        # create(:job, name: 'C++ Developer')
        # create(:job, name: 'Go Developer')

        # create(:job_seeker, name: 'Alice')
        # create(:job_seeker, name: 'Bob')
      end

      it 'renders a CSV formatted list of applicants' do
        # jobseeker_id, jobseeker_name, job_id, job_title, matching_skill_count, matching_skill_percent
        # 1, Alice, 5, Ruby Developer, 3, 100
        # 1, Alice, 2, .NET Developer, 3, 75
        # 1, Alice, 7, C# Developer, 3, 75
        # 1, Alice, 4, Dev Ops Engineer, 4, 50
        # 2, Bob, 3, C++ Developer, 4, 100
        # 2, Bob, 1, Go Developer, 3, 75
      end
    end
  end
end
