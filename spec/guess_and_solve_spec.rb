# frozen_string_literal: true

RSpec.describe Sudoku::GuessAndSolve do
  let(:board) { Sudoku::Board.load_fixture(fixture) }
  let(:fixture) { 'evil' }
  let(:subject) { described_class.call(board) }

  before { Sudoku::Solver.new(board).solve }

  describe '#call' do
    it "stores guesses on board" do
      expect(board.guesses).to eq nil
      subject
      expect(board.guesses.count { |k, v| v.size >= 1 }).to eq 1
    end

    it 'fills in missing values when solved' do
      expect { 100.times { described_class.call(board) }}.to change { board.solved? }.from(false).to(true)
    end

    it "doesn't guess the same cell/value twice" do
      100.times { described_class.call(board) }
      expect(board.guesses.count { |k, v| v.size > 2 }).to eq 0
    end
  end
end