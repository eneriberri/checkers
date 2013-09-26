require 'colorize'
require_relative 'piece'

class Board
  attr_accessor :board

  def initialize
    @board = Array.new(8) { Array.new(8) }
    set_board
  end

  def set_board
    [:red, :white].each { |color| fill_rows(color); fill_midrows(color) }
  end

  def fill_rows(color)
    i = color == :red ? [0,2] : [5, 7]
    i.each do |row|
      8.times do |col|
        next if col.even? && color == :red
        next if col.odd? && color == :white

        self.board[row][col] = Piece.new(self.board, color, [row, col])
      end
    end
  end

  def fill_midrows(color)
    row = color == :red ? 1 : 6

    8.times do |col|
      next if col.odd? && color == :red
      next if col.even? && color == :white
      #pos = [row, col]   >.<
      self.board[row][col] = Piece.new(self.board, color, [row, col])
    end

  end

  def display
    print " "; 8.times { |num| print "  #{num} ".colorize(:magenta)}; puts ""
    board.each_with_index do |row, index|
      print "#{index} ".colorize(:magenta)
      row.each do |piece|
        print piece.is_a?(Piece) ? piece.to_s + " " : " __ ".colorize(:blue)
      end
      puts ""
    end
    puts "\n---------------------------------"
  end

  def [](pos)
    row, col = pos
    board[row][col]
  end

  def []=(pos, val)
    row, col = pos
    self.board[row][col] = val
  end

  def valid_pos?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def opponent?(pos, color)
    self[pos].is_a?(Piece) && self[pos].color != color
  end

end


b = Board.new
b.display

p = Piece.new(b, :red, [0,1])
p p.jump_moves
p p.slide_moves