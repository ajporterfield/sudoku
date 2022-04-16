# frozen_string_literal: true

module Sudoku
  class Cell
    attr_reader :x, :y
    attr_accessor :value, :exclusions

    def initialize(x:, y:, value: nil)
      @x = x
      @y = y
      @value = value
      @exclusions = []
    end

    def id
      (9 * y) + x
    end

    def row_id
      y
    end

    def column_id
      x
    end

    def block_id
      ((y / 3) * 3) + (x / 3)
    end
  end
end
