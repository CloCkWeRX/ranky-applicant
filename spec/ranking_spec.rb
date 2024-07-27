# frozen_string_literal: true

require './spec/rails_helper'

describe 'Application Output' do
  describe 'csv rendering' do
    context 'with the primary sample data' do
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

      let(:ranked_applicants) do
        ranker_service.ranked_jobs_by_job_seeker
      end

      before do
        ranker_data_manager.purge!
        ranker_data_manager.load!
      end

      it 'renders a CSV formatted list of applicants' do
        # puts ranked_applicants.inspect
      end

      describe 'Alice Seeker' do
        before do
          @results = ranked_applicants.select { |row| row[:jobseeker_name] == 'Alice Seeker' }
        end
        it 'ranks highest for a Ruby Developer (100%) role' do
          # 1,Alice Seeker,"Ruby, SQL, Problem Solving"
          # 1,Ruby Developer,"Ruby, SQL, Problem Solving"
          # puts @results[0].inspect
          expect(@results[0][:job_title]).to eq 'Ruby Developer'
          expect(@results[0][:matching_skill_count]).to eq 3
          expect(@results[0][:matching_skill_percent]).to eq 100
        end

        it 'ranks partially for a Fullstack Developer role' do
          # 1,Alice Seeker,"Ruby, SQL, Problem Solving"
          # 4,Fullstack Developer,"JavaScript, HTML/CSS, Node.js, Ruby, SQL, Communication"
          expect(@results[1][:job_title]).to eq 'Fullstack Developer'
          expect(@results[1][:matching_skill_count]).to eq 2
          # expect(@results[1][:matching_skill_percent]).to eq 66 # TODO: Is this how many of the applicant's skills match, or how many of the job's skills match?
        end
      end
      it 'ranks Ian Jobhunter lowest for Python Developer' do
        # 9,Ian Jobhunter,"JavaScript, React, Self Motivated"
        # 9,Python Developer,"Python, SQL, Problem Solving, Self Motivated"
        # 10,JavaScript Developer,"JavaScript, React, Node.js, Self Motivated"
      end
    end
  end
end
