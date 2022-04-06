# frozen_string_literal: true

RSpec.describe Sudoku::Strategies::Exclusions::BlockAndColumnRowInteraction do
  let(:board) { Sudoku::Board.load_fixture(fixture) }

  subject { described_class.call(board) }

  context 'rows' do
    let(:fixture) { "block_and_column_row_interaction_rows" }
    let(:cell_ids) { [36, 37, 38, 42, 43, 44] }

    it 'adds exclusions to corresponding rows in the other block' do
      subject
      cell_ids.each { |cell_id| expect(board.cell(cell_id).exclusions).to eq([7]) }
    end

    it "doesn't add exclusions to other cells" do
      subject
      expect(board.empty_cells.select { |c| c.exclusions.any? }.map(&:id)).to eq cell_ids
    end
  end

  context 'rows' do
    let(:fixture) { "block_and_column_row_interaction_columns" }
    let(:cell_ids) { [4, 13, 22, 58, 67, 76] }

    it 'adds exclusions to corresponding rows in the other block' do
      subject
      cell_ids.each { |cell_id| expect(board.cell(cell_id).exclusions).to eq([7]) }
    end

    it "doesn't add exclusions to other cells" do
      subject
      expect(board.empty_cells.select { |c| c.exclusions.any? }.map(&:id)).to eq cell_ids
    end
  end
end