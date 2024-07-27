# frozen_string_literal: true

namespace :ranker do
  desc 'Load data from a given directory into the current environment. See spec/test_data/ for examples of format'
  task load_data: [:path] => :environment do |t, args|
    raise ArgumentError, "Missing path" unless args[:path]
    raise ArgumentError, "Missing path on disk" unless Dir.exist?(args[:path])

    raise ArgumentError, "Missing jobs.csv" unless File.exists?("#{args[:path]}/jobs.csv")
    raise ArgumentError, "Missing jobseekers.csv" unless File.exists?("#{args[:path]}/jobseekers.csv")
    
    raise ArgumentError, "Not readable jobs.csv - check permissions" unless File.readable?("#{args[:path]}/jobs.csv")
    raise ArgumentError, "Not readable jobseekers.csv - check permissions" unless File.readable?("#{args[:path]}/jobseekers.csv")
  
    jobs_data = CSV.read("#{args[:path]}/jobs.csv", headers: true)
    job_seekers_data = CSV.read("#{args[:path]}/jobseekers.csv", headers: true)

    ranker_data_manager = Ranker::DataManager.new(jobs_data, job_seekers_data)
    ranker_data_manager.purge!
    ranker_data_manager.load!
  end

  desc 'Load data from a given directory into the current environment. See spec/test_data/ for examples of format'
  task :display => :environment do
    puts Ranker::CSVSerializer.new(ranker_service.ranked_jobs_by_job_seeker).to_s
  end
end
