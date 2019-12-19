# frozen_string_literal: true

module Errors
  class GuessLengthError < StandardError
    def initialize
      super('The  length must be 4 digit')
    end
  end
end
