# frozen_string_literal: true

Dir['./lib/sudoku/strategies/**/*.rb'].sort.each { |f| require f }

module Sudoku
  class Solver
    attr_reader :board

    def initialize(board)
      @board = board
    end

    # This method is recursive - continuing to try and solve the puzzle as new
    # values are found and/or candidates eliminated.
    def solve
      loop do
        break unless add_values
      end

      return solve if add_exclusions
      board.solved?
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
