module Sudoku
  class Grouping
    attr_reader :id, :cells

    def initialize(id: id, cells: cells)
      @id = id
      @cells = cells
    end

    def related_empty_cells(cell)
      empty_cells & related_cells(cell)
    end

    def values
      cells.map(&:value).compact
    end

    def empty_cells
      cells.select(&:empty?)
    end

    def related_cells(cell)
      cells.reject { |c| c.id == cell.id }
    end
  end
end