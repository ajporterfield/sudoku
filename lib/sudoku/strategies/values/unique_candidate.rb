# frozen_string_literal: true

# See https://www.kristanix.com/sudokuepic/sudoku-solving-techniques.php
# You know that each block, row and column on a Sudoku board must contain every
# number between 1 and 9. Therefore, if a number, say 4, can only be put in a
# single cell within a block/column/row, then that number is guaranteed to fit there.

module Sudoku
  module Strategies
    module Values
      class UniqueCandidate
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
            unique_candidate = %i[row column block].map do |row_column_or_block|
              remaining_cells = board.send("#{row_column_or_block}s")[cell.send("#{row_column_or_block}_id")].cells - [cell]
              remaining_candidates = board.candidates(cell) - remaining_cells.map { |rc| board.candidates(rc) }.flatten.uniq
              remaining_candidates[0] if remaining_candidates.size == 1
            end.compact[0]

            if unique_candidate
              cell.value = unique_candidate
              added_values = true
            end
          end

          added_values
        end
      end
    end
  end
end
