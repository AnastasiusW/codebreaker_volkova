# frozen_string_literal: true

module Errors
  class NilStringError < StandardError
    def initialize
      super('Parameter must be not nil!')
    end
  end
end
