# frozen_string_literal: true

require 'json'
require 'byebug'

require './lib/sudoku/grouping'
Dir['./lib/sudoku/**/*.rb'].sort.each { |f| require f }
