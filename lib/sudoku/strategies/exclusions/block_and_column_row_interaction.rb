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
            board.candidates(cell).each do |candidate|
              matches = board.blocks[cell.block_id].related_empty_cells(cell).select { |c| board.candidates(c).include?(candidate) }
              next unless matches.size == 1

              cells_to_update = if matches[0].x == cell.x
                                  board.cells.map do |r|
                                    r.find do |c|
                                      c.x == cell.x && !board.blocks[cell.block_id].cells.map(&:y).include?(c.y)
                                    end
                                  end.compact
                                elsif matches[0].y == cell.y
                                  board.rows[cell.row_id].cells.reject { |c| board.blocks[cell.block_id].cells.map(&:x).include?(c.x) }
                                else
                                  []
                                end

              cells_to_update.each do |cell_to_update|
                next unless board.candidates(cell_to_update).include?(candidate)

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
