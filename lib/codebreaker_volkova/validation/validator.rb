# frozen_string_literal: true

module CodebreakerVolkova
  module Validator
    include Errors

    VALID_NAME_LENGTH = (3..20).freeze
    VALID_NUMBERS = (1..6).freeze
    VALID_GUESS_LENGTH = 4
    LEVEL_OF_GAME = %w[easy medium hell].freeze

    def not_empty?(*args)
      args.each do |arg|
        raise NilStringError if arg.nil?
        raise EmptyStringError if arg.empty?
      end
    end

    def instance?(main_class, *args)
      args.each do |object|
        raise NilStringError if object.nil?
        raise WrongClassError unless object.instance_of?(main_class)
      end
    end

    def check_length_name?(arg)
      raise UserNameError unless VALID_NAME_LENGTH.include?(arg.length)
    end

    def check_length_guess?(guess)
      raise GuessLengthError unless guess.length == VALID_GUESS_LENGTH
    end

    def check_constituents_guess?(guess)
      raise GuessError unless guess.each_char.map(&:to_i).all? do |num|
        VALID_NUMBERS.include?(num)
      end
    end

    def check_constituents_difficulty?(difficulty)
      raise DifficultyError unless LEVEL_OF_GAME.include? difficulty
    end
  end
end
