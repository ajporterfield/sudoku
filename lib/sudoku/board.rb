# frozen_string_literal: true

require 'json'
require 'sudoku/solver'
require 'sudoku/guess_and_solve'
require 'sudoku/cell'
require 'sudoku/row'
require 'sudoku/column'
require 'sudoku/block'

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

    private

    def create_cells(values)
      @cells = values.flatten.map.with_index do |value, id|
        Sudoku::Cell.new(id: id, value: value)
      end
    end

    def create_groupings
      %i[row column block].each do |grouping_name|
        groupings = (0..8).map do |id|
          grouping_class = Object.const_get("Sudoku::#{grouping_name.capitalize}")
          grouping_cells = cells.select { |c| c.send("#{grouping_name}_id") == id }
          grouping_class.new(id: id, cells: grouping_cells)
        end

        instance_variable_set("@#{grouping_name}s", groupings)
      end
    end
  end
end
