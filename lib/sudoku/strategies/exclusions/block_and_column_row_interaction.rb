# frozen_string_literal: true

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

          board.empty_cells.each do |cell|
            cell.candidates.each do |candidate|
              matches = cell.related_empty_cells(:block).select { |c| c.candidates.include?(candidate) }
              next unless matches.size == 1

              cells_to_update = if matches[0].x == cell.x
                                  board.cells.map do |r|
                                    r.find do |c|
                                      c.x == cell.x && !cell.block.map(&:y).include?(c.y)
                                    end
                                  end.compact
                                elsif matches[0].y == cell.y
                                  board.row(cell.y).reject { |c| cell.block.map(&:x).include?(c.x) }
                                else
                                  []
                                end

              cells_to_update.each do |cell_to_update|
                next if cell_to_update.exclusions.include?(candidate)

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
