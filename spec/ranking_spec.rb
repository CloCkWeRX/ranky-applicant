# frozen_string_literal: true

require './spec/rails_helper'

describe 'Application Output' do
  describe 'csv rendering' do
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
      let(:output) do
        Ranker::CSVSerializer.new(ranked_applicants).to_s
      end

      before do
        ranker_data_manager.purge!
        ranker_data_manager.load!
      end

      it 'renders a CSV formatted list of applicants' do
        expect(output.split("\n")[0]).to eq('jobseeker_id,jobseeker_name,job_id,job_title,matching_skill_count,matching_skill_percent')

        expect(output.split("\n")[104]).to match(/\d+,JavaScript Developer,\d+,JavaScript Developer,4,100/)
        expect(output.split("\n")[105]).to match(/\d+,JavaScript Developer,\d+,Frontend Developer,2,50/)
        expect(output.split("\n")[106]).to match(/\d+,JavaScript Developer,\d+,Fullstack Developer,2,33/)
        expect(output.split("\n")[107]).to match(/\d+,JavaScript Developer,\d+,Backend Developer,1,25/)
        expect(output.split("\n")[108]).to match(/\d+,JavaScript Developer,\d+,Web Developer,1,25/)
        expect(output.split("\n")[109]).to match(/\d+,JavaScript Developer,\d+,Python Developer,1,25/)
      end

      describe 'Alice Seeker' do
        before do
          @results = ranked_applicants.select { |row| row[:jobseeker_name] == 'Alice Seeker' }
        end

        it 'ranks highest for a Ruby Developer (100%) role' do
          # 1,Alice Seeker,"Ruby, SQL, Problem Solving"
          # 1,Ruby Developer,"Ruby, SQL, Problem Solving"
          expect(@results[0][:job_title]).to eq 'Ruby Developer'
          expect(@results[0][:matching_skill_count]).to eq 3
          expect(@results[0][:matching_skill_percent]).to eq 100
        end

        it 'ranks partially for a Backend Developer, then Fullstack Developer role' do
          # 1,Alice Seeker,"Ruby, SQL, Problem Solving"
          # 3,Backend Developer,"Java, SQL, Node.js, Problem Solving"
          # 4,Fullstack Developer,"JavaScript, HTML/CSS, Node.js, Ruby, SQL, Communication"

          expect(@results[1][:job_title]).to eq 'Backend Developer'
          expect(@results[1][:matching_skill_count]).to eq 2
          expect(@results[1][:matching_skill_percent]).to eq 50 # 2 of 4 skills for the job

          expect(@results[2][:job_title]).to eq 'Fullstack Developer'
          expect(@results[2][:matching_skill_count]).to eq 2
          expect(@results[2][:matching_skill_percent]).to eq 33 # 2 of 6 skills
        end

        it 'ranks by job id ascending when equally applicable' do
          expect(@results[4][:matching_skill_count]).to eq @results[5][:matching_skill_count] # Both have only 1/4 skills

          expect(@results[4][:job_id] < @results[5][:job_id]).to be true
        end
      end

      describe 'Ian Jobhunter' do
        before do
          @results = ranked_applicants.select { |row| row[:jobseeker_name] == 'Ian Jobhunter' }
        end

        it 'ranks lowest for Python Developer' do
          # 9,Ian Jobhunter,"JavaScript, React, Self Motivated"
          # 9,Python Developer,"Python, SQL, Problem Solving, Self Motivated"
          # 10,JavaScript Developer,"JavaScript, React, Node.js, Self Motivated"
          expect(@results.last[:job_title]).to eq 'Python Developer'
          expect(@results.last[:matching_skill_count]).to eq 1
          expect(@results.last[:matching_skill_percent]).to eq 25
        end
      end
    end
  end
end
