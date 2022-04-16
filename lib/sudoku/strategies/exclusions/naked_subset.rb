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
              %i[row column block].each do |row_column_or_block|
                next unless board.candidates(cell).size == subset

                related_empty_cells = board.related_empty_cells(cell, row_column_or_block)
                matches = related_empty_cells.select { |c| board.candidates(c) == board.candidates(cell) }
                next unless matches.size == (subset - 1)

                other_cells = related_empty_cells.reject { |c| matches.map(&:id).include?(c.id) }
                other_cells.each do |other_cell|
                  next if (board.candidates(cell) - other_cell.exclusions).empty?

                  other_cell.exclusions += board.candidates(cell)
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
