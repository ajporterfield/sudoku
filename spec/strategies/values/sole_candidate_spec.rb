# frozen_string_literal: true

RSpec.describe Sudoku::Strategies::Values::SoleCandidate do
  let(:board) { Sudoku::Board.load_fixture("sole_candidate") }

  subject { described_class.call(board) }

  it 'finds and fills in sole candidates' do
    expect { subject }.to change { board.cell(50).value }.from(nil).to(5)
  end
end