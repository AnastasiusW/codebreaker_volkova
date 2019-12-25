# frozen_string_literal: true

require 'codebreaker_volkova/version'
require 'yaml'

require_relative 'codebreaker_volkova/errors/difficulty_error'
require_relative 'codebreaker_volkova/errors/empty_string_error'
require_relative 'codebreaker_volkova/errors/guess_error'
require_relative 'codebreaker_volkova/errors/guess_length_error'
require_relative 'codebreaker_volkova/errors/nil_string_error'
require_relative 'codebreaker_volkova/errors/user_name_error'
require_relative 'codebreaker_volkova/errors/wrong_class_error'
require_relative 'codebreaker_volkova/game_business_logic'
require_relative 'codebreaker_volkova/validation/validator'
require_relative 'codebreaker_volkova/game_progress'

module CodebreakerVolkova
  class Error < StandardError; end
  # Your code goes here...
end
