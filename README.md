# Sudoku
Ruby library for solving Sudoku puzzles.  Inspired by the strategies found at https://www.kristanix.com/sudokuepic/sudoku-solving-techniques.php


## Usage

```bash
bundle install
bundle exec rspec
bin/console
```

```ruby
# create a board from an array of starting values
board = Sudoku::Board.new([
  [nil,5,6,nil,nil,nil,nil,nil,nil],
  [1,nil,nil,nil,3,nil,nil,2,nil],
  [nil,nil,3,5,nil,nil,nil,8,nil],
  [3,nil,nil,nil,nil,4,nil,nil,8],
  [7,nil,nil,nil,1,nil,nil,9,nil],
  [nil,nil,nil,nil,nil,nil,nil,nil,nil],
  [nil,nil,nil,nil,5,nil,nil,nil,6],
  [8,nil,nil,nil,9,nil,nil,nil,7],
  [6,7,nil,1,nil,nil,nil,nil,4]
])

# or create a board from one of the provided fixtures
board = Sudoku::Board.load_fixture("hard")

# solve will print out the board and return true/false
# depending on if it was solved or not
board.solve
```
