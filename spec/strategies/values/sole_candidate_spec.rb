# frozen_string_literal: true

RSpec.describe Sudoku::Strategies::Values::SoleCandidate do
  let(:board) { Sudoku::Board.load_fixture(fixture) }

  subject { described_class.call(board) }

  context "when new values are added" do
    let(:fixture) { "sole_candidate" }

    it { is_expected.to eq true }

    it 'finds and fills in sole candidates' do
      expect { subject }.to change { board.cell(50).value }.from(nil).to(5)
    end
  end

  context "when new values aren't added" do
    let(:fixture) { "solved" }

    it { is_expected.to eq false }
  end
end