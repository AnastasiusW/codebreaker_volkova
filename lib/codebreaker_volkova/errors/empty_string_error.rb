# frozen_string_literal: true

module Errors
  class EmptyStringError < StandardError
    def initialize
      super('Parameter must be not empty!')
    end
  end
end
