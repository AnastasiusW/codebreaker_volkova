# frozen_string_literal: true

require 'codebreaker_volkova/version'
require 'yaml'

require_relative 'codebreaker_volkova/game_business_logic'
require_relative 'codebreaker_volkova/validation/validator'
require_relative 'codebreaker_volkova/game_progress'

module CodebreakerVolkova
  class Error < StandardError; end
  # Your code goes here...
end
