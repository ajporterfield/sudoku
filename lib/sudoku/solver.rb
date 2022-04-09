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

    def add_values
      value_strategies.any? { |s| s.call(board) }
    end

    def add_exclusions
      exclusion_strategies.any? { |s| s.call(board) }
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
