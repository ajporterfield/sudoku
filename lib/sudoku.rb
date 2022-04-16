# frozen_string_literal: true

require 'json'
require 'byebug'

Dir['./lib/sudoku/**/*.rb'].sort.each { |f| require f }
