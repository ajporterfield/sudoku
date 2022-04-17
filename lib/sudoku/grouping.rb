module Sudoku
  class Grouping
    attr_reader :id, :cells

    def initialize(id: id, cells: cells)
      @id = id
      @cells = cells
    end

    def values
      cells.map(&:value).compact
    end

    def empty_cells
      cells.select(&:empty?)
    end
  end
end