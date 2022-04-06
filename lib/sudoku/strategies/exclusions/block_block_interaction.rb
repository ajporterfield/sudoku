# frozen_string_literal: true

# See "Block / Block Interaction" under "Techniques for removing candidates"
# at https://www.kristanix.com/sudokuepic/sudoku-solving-techniques.php

module Sudoku
  module Strategies
    module Exclusions
      class BlockBlockInteraction
        attr_reader :board

        def self.call(board)
          new(board).call
        end

        def initialize(board)
          @board = board
        end

        def call
          added_exclusions = add_block_row_exclusions
          added_exclusions ||= add_block_column_exclusions
        end

        private

        def add_block_row_exclusions
          added_exclusions = false

          (0..2).each do |i|
            block_id = i * 3

            combos = [
              [block_id, block_id + 1],
              [block_id, block_id + 2],
              [block_id + 1, block_id + 2]
            ]

            combos.each do |combo|
              block_0_row_candidates = block_row_candidates(board.block(combo[0]))
              block_1_row_candidates = block_row_candidates(board.block(combo[1]))

              (1..9).each do |candidate|
                block_0_row_indexes = block_row_indexes(candidate, block_0_row_candidates)
                block_1_row_indexes = block_row_indexes(candidate, block_1_row_candidates)
                next unless block_0_row_indexes.size == 2 && (block_0_row_indexes == block_1_row_indexes)

                other_block_id = ([block_id, block_id + 1, block_id + 2] - combo)[0]
                other_block = board.block(other_block_id)
                other_block_cells = other_block_row_cells(other_block, block_0_row_indexes[0])
                other_block_cells += other_block_row_cells(other_block, block_0_row_indexes[1])
                other_block_cells.each do |cell|
                  next unless cell.candidates.include?(candidate)

                  cell.exclusions << candidate
                  added_exclusions = true
                end
              end
            end
          end

          added_exclusions
        end

        def block_row_candidates(block)
          block_candidates = block.map(&:candidates)
          [
            block_candidates[0..2].flatten.uniq,
            block_candidates[3..5].flatten.uniq,
            block_candidates[6..8].flatten.uniq
          ]
        end

        def block_row_indexes(candidate, block_row_candidates)
          block_row_indexes = []

          block_row_candidates.each_with_index do |candidates, row_index|
            block_row_indexes << row_index if candidates.include?(candidate)
          end

          block_row_indexes
        end

        def other_block_row_cells(other_block, row)
          index = row * 3
          other_block[index..(index + 2)]
        end

        def add_block_column_exclusions
          added_exclusions = false

          (0..2).each do |i|
            combos = [
              [i, i + 3],
              [i, i + 6],
              [i + 3, i + 6]
            ]

            combos.each do |combo|
              block_0_column_candidates = block_column_candidates(board.block(combo[0]))
              block_1_column_candidates = block_column_candidates(board.block(combo[1]))

              (1..9).each do |candidate|
                block_0_column_indexes = block_row_indexes(candidate, block_0_column_candidates)
                block_1_column_indexes = block_row_indexes(candidate, block_1_column_candidates)
                next unless block_0_column_indexes.size == 2 && (block_0_column_indexes == block_1_column_indexes)

                other_block_id = ([i, i + 3, i + 6] - combo)[0]
                other_block = board.block(other_block_id)
                other_block_cells = other_block_column_cells(other_block, block_0_column_indexes[0])
                other_block_cells += other_block_column_cells(other_block, block_1_column_indexes[1])
                other_block_cells.each do |cell|
                  next unless cell.candidates.include?(candidate)

                  cell.exclusions << candidate
                  added_exclusions = true
                end
              end
            end
          end

          added_exclusions
        end

        def block_column_candidates(block)
          block_candidates = block.map(&:candidates)
          [
            block_candidates.select.with_index { |bc, i| [0, 3, 6].include?(i) }.flatten.uniq,
            block_candidates.select.with_index { |bc, i| [1, 4, 7].include?(i) }.flatten.uniq,
            block_candidates.select.with_index { |bc, i| [2, 5, 8].include?(i) }.flatten.uniq
          ]
        end

        def other_block_column_cells(other_block, column)
          other_block.select.with_index { |c, i| [column, column + 3, column + 6].include?(i) }
        end
      end
    end
  end
end