# frozen_string_literal: true

module Sudoku
  class Solver
    attr_reader :board

    def initialize(board)
      @board = board
    end

    # This method is recursive - continuing to try and solve the puzzle as new
    # values are found and/or candidates eliminated.
    def solve
      repeat = true
      repeat = add_values while repeat

      solve if add_exclusions
    end

    def guess
      cell = board.empty_cells.sample { |c| c.candidates.size == 2 }
      return unless cell

      cell.value = cell.candidates.sample
    end

    private

    # Originally these two methods called any?, but map/reduce is now used so
    # we don't return early from the first strategy that returns true.
    # We want all strategies to run each pass.
    def add_values
      value_strategies.map { |s| s.call(board) }.reduce(&:|)
    end

    def add_exclusions
      exclusion_strategies.map { |s| s.call(board) }.reduce(&:|)
    end

    def value_strategies
      strategies('values')
    end

    def exclusion_strategies
      strategies('exclusions')
    end

    def strategies(type)
      Dir["./lib/sudoku/strategies/#{type}/*.rb"].map do |f|
        File.basename(f, '.rb').split('_').map(&:capitalize).join
      end.map do |s|
        Object.const_get("Sudoku::Strategies::#{type.capitalize}::#{s}")
      end
    end
  end
end
