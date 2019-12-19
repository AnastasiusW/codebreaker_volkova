# frozen_string_literal: true

module CodebreakerVolkova
  class Game
    include GameBusinessLogic
    include Validator

    attr_reader :username, :difficulty, :hints, :attempts, :attempts_total,
                :hints_total, :secret_code

    FILENAME = 'store.yml'
    SIGN_CONSTANT = 4
    NUMBER_CONSTANT = 6

    def initialize
      @game_over = false
    end

    def start
      @secret_code = generate_secret_number
      @hints_code = @secret_code.dup.shuffle
    end

    def add_name(name)
      validate_name(name)
      @username = name
    end

    def add_difficulty(difficulty)
      validate_difficulty(difficulty)
      @difficulty = difficulty
      @attempts_total = take_attempt(difficulty)
      @attempts = @attempts_total
      @hints_total = take_hint(difficulty)
      @hints = @hints_total
    end

    def check_result(guess)
      validate_guess(guess)
      guess = guess.each_char.map(&:to_i)
      result = take_result(@secret_code, guess)
      @game_over = true if result == GameBusinessLogic::RESULT_PLUS * 4
      @attempts -= 1
      result
    end

    def check_status_game
      @game_over
    end

    def attempts?
      @attempts.positive?
    end

    def hints?
      return false unless @hints.positive?

      @hints -= 1
      @hints_code.pop
    end

    def generate_secret_number(sign = SIGN_CONSTANT, number = NUMBER_CONSTANT)
      Array.new(sign) { rand(1..number) }
    end

    def save_stats(filename_path = FILENAME)
      File.open(filename_path, 'a') do |file|
        file.write(convert_to_hash.to_yaml)
      end
    end

    def convert_to_hash
      {
        name: @user_name,
        difficulty: @difficulty,
        attempts_total: @attempts_total,
        attempts_used: @attempts_total - @attempts,
        hints_total: @hints_total,
        hints_used: @hints_total - @hints
      }
    end

    def load_stats(filename_path = FILENAME)
      return false unless File.exist?(filename_path)
      return false if File.zero?(filename_path)

      documents = YAML.load_stream(File.open(filename_path))
      documents.map.sort_by do |item|
        [take_level_of_difficulty(item[:Difficulty]), item[:Attempts_Used], item[:Hints_Used]]
      end
    end

    private

    def validate_name(name)
      instance?(String, name)
      not_empty?(name)
      check_length_name?(name)
    end

    def validate_guess(guess)
      instance?(Integer, guess.to_i)
      not_empty?(guess)
      check_length_guess?(guess)
      check_constituents_guess?(guess)
    end

    def validate_difficulty(difficulty)
      instance?(String, difficulty)
      not_empty?(difficulty)
      check_constituents_difficulty?(difficulty)
    end
  end
end
