# frozen_string_literal: true

# See https://www.kristanix.com/sudokuepic/sudoku-solving-techniques.php
# When a specific cell can only contain a single number, that number is a "sole candidate".
# This happens whenever all other numbers but the candidate number exists in either the
# current block, column or row.

module Sudoku
  module Strategies
    module Values
      class SoleCandidate
        attr_reader :board

        def self.call(board)
          new(board).call
        end

        def initialize(board)
          @board = board
        end

        def call
          added_values = false

          board.empty_cells.each do |cell|
            candidates = board.candidates(cell)
            next unless candidates.size == 1

            cell.value = candidates[0]
            added_values = true
          end

          added_values
        end
      end
    end
  end
end
