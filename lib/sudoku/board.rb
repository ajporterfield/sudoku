# frozen_string_literal: true

module Sudoku
  class Board
    MAX_GUESSES = 100

    attr_reader :cells
    attr_accessor :guesses

    def self.load_fixture(name)
      new(JSON.parse(File.read("spec/fixtures/files/#{name}.json")))
    end

    def initialize(values)
      @cells = []
      create_cells(values)
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

    def row(y)
      cells[y]
    end

    def column(x)
      cells.map { |row| row[x] }
    end

    def block(block_id)
      x = (block_id % 3 * 3)
      x_range = x..(x + 2)

      y = (block_id / 3 * 3)
      y_range = y..(y + 2)

      cells[y_range].map { |r| r[x_range] }.flatten
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

    private

    def create_cells(values)
      @cells = values.map.with_index do |row, y|
        row.map.with_index do |value, x|
          Sudoku::Cell.new(board: self, x: x, y: y, value: value)
        end
      end
    end
  end
end
