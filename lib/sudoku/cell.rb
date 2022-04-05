# frozen_string_literal: true

module Sudoku
  class Cell
    attr_reader :board, :x, :y
    attr_accessor :value, :exclusions

    def initialize(board, x, y, value)
      @board = board
      @x = x
      @y = y
      @value = value
      @exclusions = []
    end

    def id
      (9 * y) + x
    end

    def row
      board.row(y)
    end

    def column
      board.column(x)
    end

    def block
      board.block(block_id)
    end

    def candidates
      ((1..9).to_a - (row_values + column_values + block_values).uniq - exclusions).sort
    end

    def related_candidates(row_column_or_block)
      related_empty_cells(row_column_or_block).map(&:candidates).flatten.uniq
    end

    def related_empty_cells(row_column_or_block)
      send(row_column_or_block).select { |c| c.id != id && c.value.nil? }
    end

    private

    def row_values
      row.map(&:value).compact
    end

    def column_values
      column.map(&:value).compact
    end

    def block_values
      block.map(&:value).compact
    end

    def block_id
      ((y / 3) * 3) + (x / 3)
    end
  end
end
