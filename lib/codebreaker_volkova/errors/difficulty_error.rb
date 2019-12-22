# frozen_string_literal: true

module CodebreakerVolkova
  module Errors
    class DifficultyError < StandardError
      def initialize
        super('The difficulty must be easy or medium or hell')
      end
    end
  end
end
