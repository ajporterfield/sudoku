# frozen_string_literal: true

RSpec.describe Sudoku::Strategies::Exclusions::HiddenSubset do
  let(:board) { Sudoku::Board.load_fixture(fixture) }

  subject { described_class.call(board) }

  context "when new exclusions are added" do
    let(:fixture) { "hidden_subset" }
    let(:cell_60) { board.cell(60) }
    let(:cell_78) { board.cell(78) }

    it { is_expected.to eq true }

    it 'finds hidden subsets and removes candidates' do
      expect { subject }.to change { board.candidates(cell_60) }.from([1, 2, 3, 8, 9]).to([8, 9])
                        .and change { board.candidates(cell_78) }.from([2, 3, 5, 8, 9]).to([8, 9])
    end
  end

  context "when new exclusions aren't added" do
    let(:fixture) { "solved" }

    it { is_expected.to eq false }
  end
end