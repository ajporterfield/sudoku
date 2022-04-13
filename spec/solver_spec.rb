# frozen_string_literal: true

RSpec.describe Sudoku::Solver do
  let(:board) { Sudoku::Board.load_fixture(fixture) }
  let(:fixture) { 'easy' }
  let(:solver) { described_class.new(board) }

  describe '#solve' do
    subject { solver.solve }

    %w[easy medium hard].each do |difficulty|
      context "#{difficulty} puzzles" do
        let(:fixture) { difficulty }

        it { is_expected.to eq true }

        it "can solve #{difficulty} puzzles" do
          expect { subject }.to change { board.solved? }.from(false).to(true)
        end
      end
    end

    %w[expert evil].each do |difficulty|
      context "#{difficulty} puzzles" do
        let(:fixture) { difficulty }

        it { is_expected.to eq false }

        it "can't solve #{difficulty} puzzles without guessing" do
          expect { subject }.not_to change { board.solved? }
        end
      end
    end
  end
end
