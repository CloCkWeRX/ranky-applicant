# README

A command line application running on sqlite to rank job seekers to jobs.

The recommended way to trial this is to start a new Codespace (Code > Codespaces > Create a codespace on main)

![image](https://github.com/user-attachments/assets/8d330aa2-c645-4adc-8363-574e11883d55)

## Available rake tasks

    rake ranker:display                     # Output the ranked list of jobseekers to jobs from the loaded data
    rake ranker:load_data[path]             # Load data from a given directory into the current environment

## First install and usage

Assuming the availability of ruby 3.2.4

    bundle
    bundle exec rake db:create && bundle exec rake db:migrate
    bundle exec rake ranker:load_data[spec/test_data/]
    bundle exec rake ranker:display


## Specification

See [job_match_recommendation_challenge.md](job_match_recommendation_challenge.md)
