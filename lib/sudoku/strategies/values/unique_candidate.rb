# frozen_string_literal: true

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
              related_candidates = cell.related_candidates(row_column_or_block)
              remaining_candidates = cell.candidates - related_candidates
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
