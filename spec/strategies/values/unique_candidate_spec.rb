# frozen_string_literal: true

RSpec.describe Sudoku::Strategies::Values::UniqueCandidate do
  let(:board) { Sudoku::Board.load_fixture(fixture) }

  subject { described_class.call(board) }

  context "when new values are added" do
    let(:fixture) { "unique_candidate" }

    it { is_expected.to eq true }

    it 'finds and fills in unique candidates' do
      expect { subject }.to change { board.cells[63].value }.from(nil).to(4)
    end
  end

  context "when new values aren't added" do
    let(:fixture) { "solved" }

    it { is_expected.to eq false }
  end
end