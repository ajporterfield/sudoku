# frozen_string_literal: true

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

                results = (1..9).each_with_object({}) do |num, res|
                  res[num.to_s] = row_column_or_block.map.with_index do |c, index|
                    index if c.value.nil? && c.candidates.include?(num)
                  end.compact
                end
                results = results.select { |_k, v| v.size == subset && results.count { |_k2, v2| v == v2 } == subset }
                results.values.uniq.each do |indexes|
                  values = results.select { |_k, v| indexes == v }.keys.map(&:to_i)
                  cells = indexes.map { |index| row_column_or_block[index] }
                  other_candidates = cells.map(&:candidates).flatten.uniq - values
                  next if other_candidates.empty?

                  cells.each do |cell|
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
