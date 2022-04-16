# frozen_string_literal: true

# See "Hidden Subset" under "Techniques for removing candidates"
# at https://www.kristanix.com/sudokuepic/sudoku-solving-techniques.php

module Sudoku
  module Strategies
    module Exclusions
      class HiddenSubset
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
            (0..8).each do |i|
              %i[row column block].each do |row_column_or_block_sym|
                row_column_or_block = board.send(row_column_or_block_sym, i)
                candidates = row_column_or_block.map { |c| board.candidates(c) }.flatten.uniq.sort

                # board = Sudoku::Board.load_fixture("hard")
                # Build a hash where the keys are the unique candidates represented in the
                # row, column, or block and the values are an array of cell ids where each
                # candidat is present.
                # {
                #   "2" => [3, 4, 5, 6, 7, 8],
                #   "3" => [3, 4, 5, 7, 8],
                #   "5" => [4, 5, 7],
                #   "6" => [4, 5],
                #   "7" => [4, 5],
                #   "9" => [6, 8]
                # }
                results = candidates.each_with_object({}) do |candidate, hash|
                  hash[candidate.to_s] = row_column_or_block.map do |cell|
                    cell.id if board.candidates(cell).include?(candidate)
                  end.compact.sort
                end

                # Now filter that hash down to only include pairs of candidates that only
                # exist in 2 different cells in the row, column, or block (assumes subset is 2).
                # {
                #   "6" => [4, 5],
                #   "7" => [4, 5],
                # }
                results = results.select { |_k, v| v.size == subset && results.count { |_k2, v2| v == v2 } == subset }

                # We can now eliminate other candidates for these cells since we know they
                # can only be one of values in the subset.
                results.values.uniq.each do |cell_ids|
                  candidates = results.select { |_k, v| cell_ids == v }.keys.map(&:to_i)

                  cells = cell_ids.map { |cell_id| board.cell(cell_id) }
                  cells.each do |cell|
                    other_candidates = board.candidates(cell) - candidates
                    next if other_candidates.empty?

                    cell.exclusions += other_candidates
                    added_exclusions = true
                  end
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
