# frozen_string_literal: true

RSpec.describe Sudoku::Cell do
  let(:board) { Sudoku::Board.load_fixture(fixture) }
  let(:fixture) { 'easy' }
  let(:cell) { described_class.new(board, 4, 3, 9) }

  describe '#id' do
    subject { cell.id }

    it { is_expected.to eq 31 }
  end

  describe '#row' do
    subject { cell.row }

    it { is_expected.to eq board.row(cell.y) }
  end

  describe '#column' do
    subject { cell.column }

    it { is_expected.to eq board.column(cell.x) }
  end

  describe '#block' do
    subject { cell.block }

    it { is_expected.to eq board.block(4) }
  end
end
