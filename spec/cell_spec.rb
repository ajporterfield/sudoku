# frozen_string_literal: true

RSpec.describe Sudoku::Cell do
  let(:board) { Sudoku::Board.load_fixture(fixture) }
  let(:fixture) { 'easy' }
  let(:cell) { described_class.new(x: 4, y: 3, value: 9) }

  describe '#id' do
    subject { cell.id }

    it { is_expected.to eq 31 }
  end

  describe '#row_id' do
    subject { cell.row_id }

    it { is_expected.to eq 3 }
  end

  describe '#column_id' do
    subject { cell.column_id }

    it { is_expected.to eq 4 }
  end

  describe '#block_id' do
    subject { cell.block_id }

    it { is_expected.to eq 4 }
  end
end
