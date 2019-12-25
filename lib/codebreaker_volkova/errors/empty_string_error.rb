# frozen_string_literal: true

module CodebreakerVolkova
  module Errors
    class EmptyStringError < StandardError
      def initialize
        super('Parameter must be not empty!')
      end
    end
  end
end
