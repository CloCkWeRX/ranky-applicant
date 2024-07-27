# frozen_string_literal: true

module Ranker
  # A service for evaluating the ranked intersection of JobSeekers to Jobs
  # via the overlap of skills presented vs required.
  #
  # TODO: At a later time, inject a strategy pattern for different matching strategies
  class RankerService
    # Return a ranked, ordered result set of (roughly)
    #
    # jobseeker_id, jobseeker_name, job_id, job_title, matching_skill_count, matching_skill_percent
    # 1, Alice, 5, Ruby Developer, 3, 100
    # 1, Alice, 2, .NET Developer, 3, 75
    # 1, Alice, 7, C# Developer, 3, 75
    # 1, Alice, 4, Dev Ops Engineer, 4, 50
    # 2, Bob, 3, C++ Developer, 4, 100
    # 2, Bob, 1, Go Developer, 3, 75
    #
    # The matching skill percentage is calculated against the total skills required for the job (best applicant for job)
    # rather than the best matching job for the applicant (best job for applicant)
    #
    # Identify all skills where there is an overlap at all
    # - Find all job seekers' skills
    # - Find the jobs that require those skills
    # - And in order of the job seeker's identifier, return the highest to lowest ranking
    def ranked_jobs_by_job_seeker
      # TODO: Change to a left join if "0% overlap" is required
      # TODO: Go add scenic, flip this into a database view
      sql = "SELECT
                COUNT(job_seeker_skills.id) as matching_skills_count,
                job_seeker_skills.job_seeker_id,
                job_skills.job_id
            FROM job_seeker_skills
            JOIN job_skills ON job_seeker_skills.skill = job_skills.skill
            GROUP BY job_skills.job_id, job_seeker_skills.job_seeker_id
            ORDER BY job_seeker_skills.job_seeker_id, COUNT(job_seeker_skills.id) DESC"
      result = ActiveRecord::Base.connection.select_all(sql)
      result.map do |row|
        # TODO: Eager load
        job_seeker = JobSeeker.find(row['job_seeker_id'])
        job = Job.find(row['job_id'])

        {
          jobseeker_id: job_seeker.id,
          jobseeker_name: job_seeker.name,
          job_id: job.id,
          job_title: job.name,
          matching_skill_count: row['matching_skills_count'],
          matching_skill_percent: row['matching_skills_count'] * 100 / job.job_skills.count,
          job_skills: job.job_skills.collect(&:skill),
          job_seeker_skills: job_seeker.job_seeker_skills.collect(&:skill)
        }
      end
    end
  end

  # A class to parse and validate; then load CSV data for use with the application.
  #
  # This tooling does not support updating, but instead resets the entire state to empty and
  # loads data.
  class DataManager
    # TODO: Violates SRP slightly. If jobs data and job seeker data changed at different rates, this class should be split in two
    def initialize(jobs_data, job_seekers_data)
      raise ArgumentError, "Expected jobs_data to be a CSV::Table, got #{jobs_data.class.name}" unless jobs_data.is_a?(CSV::Table)
      raise ArgumentError, "Expected job_seekers_data to be a CSV::Table, got #{job_seekers_data.class.name}" unless job_seekers_data.is_a?(CSV::Table)

      @jobs_data = jobs_data
      @job_seekers_data = job_seekers_data
    end

    attr_accessor :jobs_data, :job_seekers_data

    # Purges all existing data
    def purge!
      Job.delete_all
      JobSeeker.delete_all
      JobSkill.delete_all
      JobSeekerSkill.delete_all
    end

    # For the provided data, populate to the database.
    #
    # Note that data is not loaded in a transaction; so
    # invalid records may require a full `purge!`
    def load!
      validate_jobs_data!
      validate_jobseekers_data!

      jobs_data.each do |row|
        job = Job.create!(name: row['title'])
        row['required_skills'].split(', ').each do |required_skill|
          job.job_skills << JobSkill.new(skill: required_skill.strip)
        end
      end

      job_seekers_data.each do |row|
        job_seeker = JobSeeker.create!(name: row['name'])
        row['skills'].split(', ').each do |required_skill|
          job_seeker.job_seeker_skills << JobSeekerSkill.new(skill: required_skill.strip)
        end
      end
    end

    private

    def validate_jobs_data!
      expected_headers = %w[id title required_skills]
      raise IOError, "jobs_data lacks expected headers: #{expected_headers.inspect}" unless jobs_data.headers == expected_headers
    end

    def validate_jobseekers_data!
      expected_headers = %w[id name skills]
      raise IOError, "job_seekers_data lacks expected headers: #{expected_headers.inspect}" unless job_seekers_data.headers == expected_headers
    end
  end

  # A class for serializing data structures as CSV format
  class CSVSerializer
    def initialize(results)
      @results = results
    end

    attr_accessor :results

    # Output formatted resultset
    #
    # jobseeker_id, jobseeker_name, job_id, job_title, matching_skill_count, matching_skill_percent
    # 1, Alice, 5, Ruby Developer, 3, 100
    # 1, Alice, 2, .NET Developer, 3, 75
    # 1, Alice, 7, C# Developer, 3, 75
    # 1, Alice, 4, Dev Ops Engineer, 4, 50
    # 2, Bob, 3, C++ Developer, 4, 100
    # 2, Bob, 1, Go Developer, 3, 75
    #
    # TODO: For larger resultsets, ideally this would be streaming / yield to output line by line
    # TODO: Assert the resultset constains the headers expected in all cases.
    def to_s
      return 'Empty resultset' unless results.any?

      headers = %w[jobseeker_id jobseeker_name job_id job_title matching_skill_count matching_skill_percent]

      CSV.generate do |csv|
        csv << headers
        results.each do |result|
          line = headers.map { |header| result[header.to_sym] }
          csv << line
        end
      end
    end
  end
end
