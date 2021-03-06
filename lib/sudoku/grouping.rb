module Sudoku
  class Grouping
    attr_reader :id, :cells

    def initialize(id:, cells:)
      @id = id
      @cells = cells
    end

    def values
      cells.map(&:value).compact
    end

    def empty_cells
      cells.select(&:empty?)
    end

    def candidates(board)
      cells.map { |c| c.candidates(board) }.flatten.uniq.sort
    end
  end
end