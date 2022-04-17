# frozen_string_literal: true

module Sudoku
  class Board
    MAX_GUESSES = 100

    attr_reader :cells, :rows, :columns, :blocks
    attr_accessor :guesses

    def self.load_fixture(name)
      new(JSON.parse(File.read("spec/fixtures/files/#{name}.json")))
    end

    def initialize(values)
      create_cells(values)
      create_groupings
    end

    def solve
      Sudoku::Solver.new(self).solve

      # If we can't solve via deduction, then we try to guess the value of
      # a single cell with 2 possible candidates. If we're still unable to solve
      # we rollback and try a different guess.
      attempts = 0
      until solved? || attempts >= MAX_GUESSES
        Sudoku::GuessAndSolve.call(self)
        attempts += 1
      end

      to_s
      solved?
    end

    def solved?
      empty_cells.empty?
    end

    def to_s
      puts rows.map { |r| r.cells.map(&:value).join(', ') }
    end

    def values
      cells.map(&:value)
    end

    def empty_cells
      cells.select(&:empty?)
    end

    def candidates(cell)
      return [] unless cell.empty?
      ((1..9).to_a - (rows[cell.row_id].values + columns[cell.column_id].values + blocks[cell.block_id].values).uniq - cell.exclusions).sort
    end

    private

    def create_cells(values)
      @cells = values.flatten.map.with_index do |value, id|
        Sudoku::Cell.new(id: id, value: value)
      end
    end

    def create_groupings
      @rows = []
      @columns = []
      @blocks = []

      (0..8).each do |id|
        @rows << Sudoku::Row.new(id: id, cells: cells.select { |c| c.row_id == id })
        @columns << Sudoku::Column.new(id: id, cells: cells.select { |c| c.column_id == id })
        @blocks << Sudoku::Block.new(id: id, cells: cells.select { |c| c.block_id == id })
      end
    end
  end
end
