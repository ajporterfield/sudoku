# frozen_string_literal: true

RSpec.describe Sudoku::Strategies::Exclusions::NakedSubset do
  let(:board) { Sudoku::Board.load_fixture("naked_subset") }

  subject { described_class.call(board) }

  [9, 27, 45, 63].each do |cell_id|
    it 'finds naked subsets and removes candidates' do
      expect { subject }.to change { board.cell(cell_id).exclusions }.from([]).to([4, 7])
    end
  end
end