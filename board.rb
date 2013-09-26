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

        self.board[row][col] = Piece.new(self, color, [row, col])
      end
    end
  end

  def fill_midrows(color)
    row = color == :red ? 1 : 6

    8.times do |col|
      next if col.odd? && color == :red
      next if col.even? && color == :white
      #pos = [row, col]   >.<
      self.board[row][col] = Piece.new(self, color, [row, col])
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

p = Piece.new(b, :red, [2,1])

p.perform_slide([3,2])
b.display

p2 = Piece.new(b, :white, [5,4])
p2.perform_slide([4,3])
b.display

p3 = b[[2,5]]
puts "red p3 pos: #{p3.pos}, slide moves: #{p3.slide_moves}, jump moves: #{p3.jump_moves}"
p3.perform_slide([3,4])
b.display
puts "white pos: #{p2.pos}, slide moves: #{p2.slide_moves}, jump moves: #{p2.jump_moves}"
# puts "red pos: #{p.pos}, slide moves: #{p.slide_moves}, jump moves: #{p.jump_moves}"
# p2.perform_jump([2,1])
# b.display

