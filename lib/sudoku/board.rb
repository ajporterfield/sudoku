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
      create_rows
      create_columns
      create_blocks
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

    def cell(id)
      cells.flatten[id]
    end

    def to_s
      puts cells.map { |r| r.map(&:value).join(', ') }
    end

    def values
      cells.map { |r| r.map(&:value) }
    end

    def empty_cells
      cells.flatten.select { |c| c.value.nil? }
    end

    def candidates(cell)
      return [] unless cell.value.nil?
      ((1..9).to_a - (rows[cell.row_id].values + columns[cell.column_id].values + blocks[cell.block_id].values).uniq - cell.exclusions).sort
    end

    def related_candidates(cell, row_column_or_block)
      send("#{row_column_or_block}s")[cell.send("#{row_column_or_block}_id")].related_empty_cells(cell).map { |c| candidates(c) }.flatten.uniq
    end

    private

    def create_cells(values)
      @cells = values.map.with_index do |row, y|
        row.map.with_index do |value, x|
          Sudoku::Cell.new(x: x, y: y, value: value)
        end
      end
    end

    def create_rows
      @rows = (0..8).map do |i|
        Sudoku::Row.new(id: i, cells: cells[i])
      end
    end

    def create_columns
      @columns = (0..8).map do |i|
        Sudoku::Column.new(id: i, cells: cells.map { |row| row[i] })
      end
    end

    def create_blocks
      @blocks = (0..8).map do |i|
        block_cells = begin
          x = (i % 3 * 3)
          x_range = x..(x + 2)

          y = (i / 3 * 3)
          y_range = y..(y + 2)

          cells[y_range].map { |r| r[x_range] }.flatten
        end

        Sudoku::Block.new(id: i, cells: block_cells)
      end
    end
  end
end
