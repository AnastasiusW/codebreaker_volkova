# frozen_string_literal: true

module CodebreakerVolkova
  module Errors
    class WrongClassError < StandardError
      def initialize
        super('Wrong class!')
      end
    end
  end
end
