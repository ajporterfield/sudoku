# frozen_string_literal: true

module Sudoku
  class Cell
    attr_reader :id
    attr_accessor :value, :exclusions

    def initialize(id:, value: nil)
      @id = id
      @value = value
      @exclusions = []
    end

    def x
      id % 9
    end

    def y
      id / 9
    end

    alias_method :row_id, :y
    alias_method :column_id, :x

    def block_id
      ((y / 3) * 3) + (x / 3)
    end

    def empty?
      value.nil?
    end
  end
end
