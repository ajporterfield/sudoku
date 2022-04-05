# frozen_string_literal: true

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
            candidates = cell.candidates
            next unless candidates.size == 1

            sole_candidate = candidates[0]
            cell.value = sole_candidate
            added_values = true
          end

          added_values
        end
      end
    end
  end
end
