# frozen_string_literal: true

describe 'Application Output' do
  describe 'csv rendering' do
    context 'with the exact sample data' do
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
