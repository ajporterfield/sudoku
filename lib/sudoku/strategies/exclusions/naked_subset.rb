# frozen_string_literal: true

# See "Naked Subset" under "Techniques for removing candidates"
# at https://www.kristanix.com/sudokuepic/sudoku-solving-techniques.php

module Sudoku
  module Strategies
    module Exclusions
      class NakedSubset
        attr_reader :board

        def self.call(board)
          new(board).call
        end

        def initialize(board)
          @board = board
        end

        def call
          added_exclusions = false

          4.downto(2).each do |subset|
            board.empty_cells.each do |cell|
              candidates = cell.candidates(board)
              next unless candidates.size == subset

              %i[row column block].each do |grouping_name|
                related_empty_cells = board.send("#{grouping_name}s")[cell.send("#{grouping_name}_id")].empty_cells - [cell]
                cells_with_matching_candidates = related_empty_cells.select { |c| c.candidates(board) == candidates }
                next unless cells_with_matching_candidates.size == (subset - 1)

                cells_to_update = related_empty_cells - cells_with_matching_candidates
                cells_to_update.each do |cell_to_update|
                  next if (candidates - cell_to_update.exclusions).empty?

                  cell_to_update.exclusions += candidates
                  added_exclusions = true
                end
              end
            end
          end

          added_exclusions
        end
      end
    end
  end
end
