# frozen_string_literal: true

require './spec/rails_helper'

describe 'Application Output' do
  describe 'csv rendering' do
    context "with the primary sample data" do
      let(:bob) { create(:job_seeker, name: 'Bob', skills: []) }
      let(:alice) { create(:job_seeker, name: 'Alice') }

      before do
        # create(:job, name: 'Ruby Developer', job_skills: [])
        # create(:job, name: '.NET Developer')
        # create(:job, name: 'C# Developer')
        # create(:job, name: 'Dev Ops Engineer')
        # create(:job, name: 'C++ Developer')
        # create(:job, name: 'Go Developer')

        # jobseeker_id, jobseeker_name, job_id, job_title, matching_skill_count, matching_skill_percent
        # 1, Alice, 5, Ruby Developer, 3, 100
        # 1, Alice, 2, .NET Developer, 3, 75
        # 1, Alice, 7, C# Developer, 3, 75
        # 1, Alice, 4, Dev Ops Engineer, 4, 50
        # 2, Bob, 3, C++ Developer, 4, 100
        # 2, Bob, 1, Go Developer, 3, 75
      end
    end

    context 'with real world sample data' do
      let(:ranker_service) { Ranker::RankerService.new }
      let(:ranker_data_manager) { Ranker::DataManager.new(jobs_data, job_seekers_data) }

      let(:jobs_data) do
        CSV.read('./spec/test_data/jobs.csv', headers: true)
      end
      let(:job_seekers_data) do
        CSV.read('./spec/test_data/jobseekers.csv', headers: true)
      end

      before do
        ranker_data_manager.purge!
        ranker_data_manager.load!
      end

      it 'renders a CSV formatted list of applicants' do
        puts ranker_service.ranked_jobs_by_job_seeker.inspect
      end
    end
  end
end
