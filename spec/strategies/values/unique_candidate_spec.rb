# frozen_string_literal: true

RSpec.describe Sudoku::Strategies::Values::UniqueCandidate do
  let(:board) { Sudoku::Board.load_fixture("unique_candidate") }

  subject { described_class.call(board) }

  it 'finds and fills in unique candidates' do
    expect { subject }.to change { board.cell(63).value }.from(nil).to(4)
  end
end