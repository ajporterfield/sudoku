# frozen_string_literal: true

RSpec.describe Sudoku::Cell do
  let(:board) { Sudoku::Board.load_fixture(fixture) }
  let(:fixture) { 'easy' }
  let(:cell) { described_class.new(id: 31, value: 9) }

  describe '#y' do
    subject { cell.y }

    it { is_expected.to eq 3 }
  end

  describe '#x' do
    subject { cell.x }

    it { is_expected.to eq 4 }
  end

  describe '#block_id' do
    subject { cell.block_id }

    it { is_expected.to eq 4 }
  end
end
