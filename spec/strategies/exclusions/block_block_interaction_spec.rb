# frozen_string_literal: true

RSpec.describe Sudoku::Strategies::Exclusions::BlockBlockInteraction do
  let(:board) { Sudoku::Board.load_fixture(fixture) }

  subject { described_class.call(board) }

  context 'rows' do
    let(:fixture) { "block_block_interaction_rows" }
    let(:cell_ids) { [33, 34, 35, 51, 52, 53] }

    it 'adds exclusions to corresponding rows in the other block' do
      subject
      cell_ids.each { |cell_id| expect(board.cell(cell_id).exclusions).to eq([8]) }
    end

    it "doesn't add exclusions to other cells" do
      subject
      expect(board.empty_cells.select { |c| c.exclusions.any? }.map(&:id)).to eq cell_ids
    end
  end

  # To help test columns, I just rotated the puzzle I'm using to verify rows.
  context 'columns' do
    let(:fixture) { "block_block_interaction_columns" }
    let(:cell_ids) { [3, 5, 12, 14, 21, 23] }

    it 'adds exclusions to corresponding rows in the other block' do
      subject
      cell_ids.each { |cell_id| expect(board.cell(cell_id).exclusions).to eq([8]) }
    end

    it "doesn't add exclusions to other cells" do
      subject
      expect(board.empty_cells.select { |c| c.exclusions.any? }.map(&:id)).to eq cell_ids
    end
  end
end