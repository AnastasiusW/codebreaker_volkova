# frozen_string_literal: true

module CodebreakerVolkova
  module Errors
    class GuessError < StandardError
      def initialize
        super('The each digit must be in the range 1-6 ')
      end
    end
  end
end
