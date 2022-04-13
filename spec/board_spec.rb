# frozen_string_literal: true

RSpec.describe Sudoku::Board do
  let(:board) { described_class.load_fixture(fixture) }
  let(:fixture) { 'solved' }

  describe '#solved?' do
    subject { board.solved? }

    context 'when all cells have a value' do
      it { is_expected.to eq true }
    end

    context "when some cells don't have a value" do
      let(:fixture) { 'easy' }

      it { is_expected.to eq false }
    end
  end

  describe '#to_s' do
    subject { board.to_s }

    it 'prints out the current values of the board' do
      values = JSON.parse(File.read("spec/fixtures/files/#{fixture}.json"))
      expect { subject }.to output(values.map { |r| r.join(', ') }.join("\n") + "\n").to_stdout
    end
  end

  describe '#cell' do
    subject { board.cell(0).value }

    it { is_expected.to eq 1 }
  end

  describe '#row' do
    subject { board.row(1).map(&:value) }

    it { is_expected.to eq [4, 5, 6, 7, 8, 9, 1, 2, 3] }
  end

  describe '#column' do
    subject { board.column(2).map(&:value) }

    it { is_expected.to eq [3, 6, 9, 4, 7, 1, 5, 8, 2] }
  end

  describe '#block' do
    subject { board.block(3).map(&:value) }

    it { is_expected.to eq [2, 3, 4, 5, 6, 7, 8, 9, 1] }
  end

  describe '#values' do
    subject { board.values }

    it {
      is_expected.to eq [
        [1, 2, 3, 4, 5, 6, 7, 8, 9],
        [4, 5, 6, 7, 8, 9, 1, 2, 3],
        [7, 8, 9, 1, 2, 3, 4, 5, 6],
        [2, 3, 4, 5, 6, 7, 8, 9, 1],
        [5, 6, 7, 8, 9, 1, 2, 3, 4],
        [8, 9, 1, 2, 3, 4, 5, 6, 7],
        [3, 4, 5, 6, 7, 8, 9, 1, 2],
        [6, 7, 8, 9, 1, 2, 3, 4, 5],
        [9, 1, 2, 3, 4, 5, 6, 7, 8]
      ]
    }
  end

  describe '#solve' do
    %w[easy medium hard expert evil].each do |difficulty|
      it "can solve #{difficulty} puzzles" do
        board = described_class.load_fixture(difficulty)
        expect(board.solve).to eq true
      end
    end

    it 'prints out the solved puzzle' do
      expect { board.solve }.to output(board.to_s).to_stdout
    end
  end
end
