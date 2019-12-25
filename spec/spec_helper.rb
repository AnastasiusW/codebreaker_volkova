# frozen_string_literal: true

require 'bundler/setup'
require 'codebreaker_volkova'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  minimum_coverage 95
end

Dir[Dir.pwd + '/spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
