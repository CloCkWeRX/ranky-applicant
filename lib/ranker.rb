# frozen_string_literal: true

# A service for evaluating the ranked intersection of JobSeekers to Jobs
# via the overlap of skills presented vs required.
class Ranker
  # Returns a descending order list of job seekers for a single, individual job
  # based on skill overlap
  def ranked_job_seekers_for_job(_job)
    []
  end

  # Returns a descending order list of jobs for a single, individual job_seeker
  # based on skill overlap
  def ranked_jobs_for_job_seeker(_job_seeker)
    []
  end

  def ranked_jobs_by_job_seeker
    # Initial, iterative approach.
    # Later refactor to SELECT (job seeker skills) INTERSECT (job skills) ORDER BY COUNT(job_seeker_id) DESC or similar
    job_seekers = JobSeeker.all
    puts job_seekers

    # jobseeker_id, jobseeker_name, job_id, job_title, matching_skill_count, matching_skill_percent
    # 1, Alice, 5, Ruby Developer, 3, 100
    # 1, Alice, 2, .NET Developer, 3, 75
    # 1, Alice, 7, C# Developer, 3, 75
    # 1, Alice, 4, Dev Ops Engineer, 4, 50
    # 2, Bob, 3, C++ Developer, 4, 100
    # 2, Bob, 1, Go Developer, 3, 75
  end
end
