# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
Dir[Rails.root.join('app/services/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('app/queries/**/*.rb')].each { |f| require f }

# rubocop:disable Style/ClassAndModuleChildren
class ActiveSupport::TestCase
  # rubocop:enable Style/ClassAndModuleChildren

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)
end
