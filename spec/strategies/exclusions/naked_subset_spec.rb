# frozen_string_literal: true

require 'sudoku/strategies/exclusions/naked_subset'
require 'sudoku/board'

RSpec.describe Sudoku::Strategies::Exclusions::NakedSubset do
  let(:board) { Sudoku::Board.load_fixture(fixture) }

  subject { described_class.call(board) }

  context "when new exclusions are added" do
    let(:fixture) { "naked_subset" }

    it { is_expected.to eq true }

    [9, 27, 45, 63].each do |cell_id|
      it 'finds naked subsets and removes candidates' do
        expect { subject }.to change { board.cells[cell_id].exclusions }.from([]).to([4, 7])
      end
    end
  end

  context "when new exclusions aren't added" do
    let(:fixture) { "solved" }

    it { is_expected.to eq false }
  end
end