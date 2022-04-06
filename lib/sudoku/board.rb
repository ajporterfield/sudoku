# frozen_string_literal: true

module Sudoku
  class Board
    attr_reader :cells

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
      #  we rollback and try a different guess.
      attempts = 0
      until solved? || attempts >= 100
        guess_and_solve
        attempts += 1
      end

      to_s
      solved?
    end

    def guess_and_solve
      new_board = self.class.new(values)
      new_solver = Sudoku::Solver.new(new_board)
      new_solver.guess
      new_solver.solve
      cells.flatten.each { |c| c.value = new_board.cell(c.id).value } if new_board.solved?
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
          Sudoku::Cell.new(self, x, y, value)
        end
      end
    end
  end
end
