# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
require 'csv'
# Add additional requires below this line. Rails is not loaded until this point!
Rails.application.eager_load!
