# frozen_string_literal: true

module Errors
  class UserNameError < StandardError
    def initialize
      super('The min length of name - 3 symbols, max length - 20')
    end
  end
end
