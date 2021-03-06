# frozen_string_literal: true

# This class attempts to solve puzzles by copying the board, looping
# through all cells with 2 remaining candidates left, guessing a value.
# Guesses are randomized (cells and values), but previous guesses are stored
# so they're not repeated.

require 'sudoku/solver'
require 'sudoku/board'

module Sudoku
  class GuessAndSolve
    attr_reader :board, :new_board

    def self.call(board)
      new(board).call
    end

    def initialize(board)
      @board = board
      board.guesses ||= build_guesses_hash_from_empty_cells
      @new_board = copy_board
    end

    def call
      guess
      Sudoku::Solver.new(new_board).solve
      return unless new_board.solved?

      add_missing_values_from_solved_board(new_board)
    end

    private

    def build_guesses_hash_from_empty_cells
      board.empty_cells.each_with_object({}) { |c, hash| hash[c.id] = [] }
    end

    def copy_board
      new_board = Sudoku::Board.new(board.values)
      board.empty_cells.select { |c| !c.exclusions.empty? }.each { |c| new_board.cells[c.id].exclusions = c.exclusions }
      new_board
    end

    def guess
      cell = cell_with_two_candidates_and_remaining_guesses
      return unless cell

      cell.value = (cell.candidates(board) - board.guesses[cell.id]).sample
      # Keeping track of guesses helps us not guess the same cell/value
      # multiple times while trying to solve.
      board.guesses[cell.id] << cell.value
    end

    def add_missing_values_from_solved_board(solved_board)
      board.empty_cells.each { |c| c.value = solved_board.cells[c.id].value }
    end

    def cell_with_two_candidates_and_remaining_guesses
      new_board.empty_cells.select do |cell|
        candidates_size = cell.candidates(board).size
        next false unless candidates_size == 2

        board.guesses[cell.id].size < candidates_size
      end.sample
    end
  end
end