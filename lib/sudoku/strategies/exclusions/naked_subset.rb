# frozen_string_literal: true

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
                next unless cell.candidates.size == subset

                related_empty_cells = cell.related_empty_cells(row_column_or_block)
                matches = related_empty_cells.select { |c| c.candidates == cell.candidates }
                next unless matches.size == (subset - 1)

                other_cells = related_empty_cells.reject { |c| matches.map(&:id).include?(c.id) }
                other_cells.each do |other_cell|
                  next if (cell.candidates - other_cell.exclusions).empty?

                  other_cell.exclusions += cell.candidates
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
