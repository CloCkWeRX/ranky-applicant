# frozen_string_literal: true

# A service for evaluating the ranked intersection of JobSeekers to Jobs
# via the overlap of skills presented vs required.
class Ranker
  def ranked_jobs_by_job_seeker
    # Identify all skills where there is an overlap at all
    # TODO: Change to a left join if "0% overlap" is required
    # TODO: Go add scenic, flip this into a database view
    sql = "SELECT
        COUNT(DISTINCT job_seeker_skills.id) as matching_skills_count, job_seeker_skills.job_seeker_id, job_skills.job_id
    FROM job_seeker_skills
    JOIN job_skills ON job_seeker_skills.skill = job_skills.skill
    GROUP BY job_skills.job_id
    ORDER BY job_seeker_skills.job_seeker_id, COUNT(DISTINCT job_seeker_skills.id) DESC"
    result = ActiveRecord::Base.connection.select_all(sql)
    result.each do |row|
      # TODO: Eager load
      job_seeker = JobSeeker.find(row['job_seeker_id'])
      job = Job.find(row['job_id'])

      puts [job_seeker.name, job.name, row['matching_skills_count'], job.job_skills.collect(&:skill), job_seeker.job_seeker_skills.collect(&:skill)].inspect
    end
    # jobseeker_id, jobseeker_name, job_id, job_title, matching_skill_count, matching_skill_percent
    # 1, Alice, 5, Ruby Developer, 3, 100
    # 1, Alice, 2, .NET Developer, 3, 75
    # 1, Alice, 7, C# Developer, 3, 75
    # 1, Alice, 4, Dev Ops Engineer, 4, 50
    # 2, Bob, 3, C++ Developer, 4, 100
    # 2, Bob, 1, Go Developer, 3, 75
  end
end
