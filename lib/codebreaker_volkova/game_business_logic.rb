# frozen_string_literal: true

module CodebreakerVolkova
  module GameBusinessLogic
    DIFFICULTIES = {
      easy: {
        attempts: 15,
        hints: 2,
        level: 3
      },
      medium: {
        attempts: 10,
        hints: 1,
        level: 2
      },
      hell: {
        attempts: 5,
        hints: 1,
        level: 1
      }
    }.freeze

    RESULT_MINUS = '-'
    RESULT_PLUS = '+'

    def take_attempt(difficulty)
      DIFFICULTIES.dig(difficulty.to_sym, :attempts)
    end

    def take_hint(difficulty)
      DIFFICULTIES.dig(difficulty.to_sym, :hints)
    end

    def take_pluses(secret_code, input_code)
      secret_code.zip(input_code).count { |a, b| a == b }
    end

    def take_result(secret_code, input_code)
      overlap = (secret_code & input_code).map do |value|
        [secret_code.count(value), input_code.count(value)].min
      end
      pluses = take_pluses(secret_code, input_code)
      minuses = overlap.sum - pluses
      RESULT_PLUS * pluses + RESULT_MINUS * minuses
    end

    def take_level_of_difficulty(difficulty)
      DIFFICULTIES.dig(difficulty.to_sym, :level)
    end
  end
end
