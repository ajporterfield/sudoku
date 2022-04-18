# frozen_string_literal: true

# See "Block and column / Row Interaction" under "Techniques for removing candidates"
# at https://www.kristanix.com/sudokuepic/sudoku-solving-techniques.php

module Sudoku
  module Strategies
    module Exclusions
      class BlockAndColumnRowInteraction
        attr_reader :board

        def self.call(board)
          new(board).call
        end

        def initialize(board)
          @board = board
        end

        def call
          added_exclusions = false

          board.empty_cells.each_with_index do |cell, index|
            cell.candidates(board).each do |candidate|
              related_empty_cells = board.blocks[cell.block_id].empty_cells - [cell]
              matches = related_empty_cells.select { |c| c.candidates(board).include?(candidate) }
              next unless matches.size == 1

              cells_to_update = if matches[0].x == cell.x
                                  board.rows.map do |r|
                                    r.cells.find do |c|
                                      c.x == cell.x && !board.blocks[cell.block_id].cells.map(&:y).include?(c.y)
                                    end
                                  end.compact
                                elsif matches[0].y == cell.y
                                  board.rows[cell.row_id].cells.reject { |c| board.blocks[cell.block_id].cells.map(&:x).include?(c.x) }
                                else
                                  []
                                end

              cells_to_update.each do |cell_to_update|
                next unless cell_to_update.candidates(board).include?(candidate)

                added_exclusions = true
                cell_to_update.exclusions << candidate
              end
            end
          end

          added_exclusions
        end
      end
    end
  end
end
