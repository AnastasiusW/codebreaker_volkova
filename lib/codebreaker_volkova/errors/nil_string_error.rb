# frozen_string_literal: true

module CodebreakerVolkova
  module Errors
    class NilStringError < StandardError
      def initialize
        super('Parameter must be not nil!')
      end
    end
  end
end
