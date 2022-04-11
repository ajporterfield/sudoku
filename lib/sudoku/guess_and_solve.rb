# frozen_string_literal: true

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
      board.empty_cells.select { |c| !c.exclusions.empty? }.each { |c| new_board.cell(c.id).exclusions = c.exclusions }
      new_board
    end

    def guess
      cell = cell_with_two_candidates_and_remaining_guesses
      return unless cell

      cell.value = (cell.candidates - board.guesses[cell.id]).sample
      board.guesses[cell.id] << cell.value
    end

    def add_missing_values_from_solved_board(solved_board)
      board.empty_cells.each { |c| c.value = solved_board.cell(c.id).value }
    end

    def cell_with_two_candidates_and_remaining_guesses
      new_board.empty_cells.select do |cell|
        candidates_size = cell.candidates.size
        next false unless candidates_size == 2
        guesses_size = board.guesses[cell.id].size
        guesses_size < candidates_size
      end.sample
    end
  end
end