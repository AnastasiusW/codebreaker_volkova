# frozen_string_literal: true

RSpec.describe CodebreakerVolkova::Game do
  subject(:game) { described_class.new }
  let(:module_class) { CodebreakerVolkova::Game }
  PATH_FILE = 'spec/support/fixtures/stats.yml'
  VALID_NAME_LENGTH = (3..20).freeze
  DIFFICULTIES_TEST = {
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

  describe '#check_result' do
    [{ secret: '6543', guess: '5643', result: '++--' },
     { secret: '6543', guess: '6411', result: '+-' },
     { secret: '6543', guess: '6544', result: '+++' },
     { secret: '6543', guess: '3456', result: '----' },
     { secret: '6543', guess: '6666', result: '+' },
     { secret: '6543', guess: '2666', result: '-' },
     { secret: '6543', guess: '2222', result: '' },
     { secret: '6666', guess: '1661', result: '++' },
     { secret: '1234', guess: '3124', result: '+---' },
     { secret: '1234', guess: '1524', result: '++-' },
     { secret: '1234', guess: '1234', result: '++++' },
     { secret: '1121', guess: '1211', result: '++--' }]
      .each do |example|
      it 'Check all combination' do
        allow(game).to receive(:generate_secret_number) { example[:secret].each_char.map(&:to_i) }
        subject.start
        subject.add_difficulty('easy')
        expect(game.check_result(example[:guess])).to eq(example[:result])
      end
    end

    context 'guess is empty' do
      let(:user_guess) { '' }
      it 'raises EmptyStringError' do
        expect { game.check_result(user_guess) }.to raise_error(module_class::EmptyStringError)
      end
    end

    context 'check_length_guess' do
      let(:user_guess) { '11' }
      it 'raises GuessLengthException' do
        expect { game.check_result(user_guess) }.to raise_error(module_class::GuessLengthError)
      end
    end

    context 'check_constituents_guess' do
      let(:user_guess) { 'aaaa' }
      it 'raises GuessException' do
        expect { game.check_result(user_guess) }.to raise_error(module_class::GuessError)
      end
    end
  end

  describe '#add_name' do
    let(:user_name) { 'Olivia' }

    it 'Check that username was set' do
      game.add_name(user_name)
      expect(game.username).to eq(user_name)
    end

    context 'name is empty' do
      let(:user_name) { '' }
      it 'raises EmptyStringError' do
        expect { game.add_name(user_name) }.to raise_error(module_class::EmptyStringError)
      end
    end

    context 'name is nil' do
      let(:user_name) { nil }
      it 'raises NilStringError' do
        expect { game.add_name(user_name) }.to raise_error(module_class::NilStringError)
      end
    end

    context 'name is short' do
      let(:user_name) { 'a' * VALID_NAME_LENGTH.max.succ }
      it 'raises UserNameException' do
        expect { game.add_name(user_name) }.to raise_error(module_class::UserNameError)
      end
    end
  end

  describe '#add_difficulty' do
    context 'when set attributes correctly ' do
      let(:user_difficulty) { 'easy' }
      let(:attempts) { DIFFICULTIES_TEST.dig(user_difficulty.to_sym, :attempts) }
      let(:hints) {  DIFFICULTIES_TEST.dig(user_difficulty.to_sym, :hints) }

      it 'it shout be set @attempts_total' do
        game.add_difficulty(user_difficulty)
        expect(game.difficulty).to eq(user_difficulty)
      end

      it 'it shout be set @attempts' do
        game.add_difficulty(user_difficulty)
        expect(game.difficulty).to eq(user_difficulty)
        expect(game.attempts).to eq(attempts)
      end

      it 'it shout be set @hints_total' do
        game.add_difficulty(user_difficulty)
        expect(game.difficulty).to eq(user_difficulty)
        expect(game.hints_total).to eq(hints)
      end

      it 'it shout be set @hints' do
        game.add_difficulty(user_difficulty)
        expect(game.hints).to eq(hints)
      end
    end

    context 'DifficultyException ' do
      let(:user_difficulty) { 'easymedium' }
      it 'raises DifficultyException ' do
        expect { game.add_difficulty(user_difficulty) }.to raise_error(module_class::DifficultyError)
      end
    end

    context 'not nill difficulty ' do
      let(:user_difficulty) { nil }
      it 'raises NilStringError ' do
        expect { game.add_difficulty(user_difficulty) }.to raise_error(module_class::NilStringError)
      end
    end

    context 'not empty difficulty ' do
      let(:user_difficulty) { '' }
      it 'raises EmptyStringError' do
        expect { game.add_difficulty(user_difficulty) }.to raise_error(module_class::EmptyStringError)
      end
    end
  end

  describe '#attempts?' do
    it 'when player has attempts' do
      game.add_difficulty('easy')
      expect(game.attempts?).to eq(true)
    end

    it 'when player has no more attempts' do
      allow(game).to receive(:generate_secret_number) { [1, 2, 3, 4] }
      game.start
      game.add_difficulty('hell')
      6.times { game.check_result('6666') }
      expect(game.attempts?).to eq(false)
    end
  end

  describe '#hints?' do
    it 'decreases hints count' do
      allow(game).to receive(:generate_secret_number) { [1, 2, 3, 4] }
      subject.start
      game.add_difficulty('easy')
      expect(game.hints?.to_s).to match(/^[1-4]$/)
    end
  end

  describe '#save_stats' do
    let(:file) { double('file') }
    let(:hash) do
      {
        name: 'Test_user',
        difficulty: 'easy',
        attempts_total: 15,
        attempts_used: 15,
        hints_total: 2,
        hints_used: 2
      }
    end
    before do
      stub_const('Game::FILENAME', PATH_FILE)
      File.delete(Game::FILENAME) if File.exist?(Game::FILENAME)
      allow(game).to receive(:convert_to_hash) { hash }
    end

    it 'Check that file was created' do
      game.save_stats(Game::FILENAME)
      expect(File.exist?(Game::FILENAME)).to be true
    end

    it 'Check if file contains correct data ' do
      game.save_stats(Game::FILENAME)
      expect(game.load_stats(Game::FILENAME)).to match([hash])
    end
  end

  describe '#load_stats' do
    let(:file) { double('file') }
    let(:hash) do
      {
        name: 'Test_user',
        difficulty: 'easy',
        attempts_total: 15,
        attempts_used: 15,
        hints_total: 2,
        hints_used: 2
      }
    end
    before do
      stub_const('Game::FILENAME', PATH_FILE)
      allow(game).to receive(:convert_to_hash) { hash }
    end

    it 'Check that file exist' do
      expect(File.exist?(Game::FILENAME)).to be true
    end

    it 'File load' do
      expect(game.load_stats(Game::FILENAME)).to match([hash])
    end
  end
end
