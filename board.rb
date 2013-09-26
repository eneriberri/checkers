require 'colorize'
require_relative 'piece'

class Board
  attr_accessor :board

  def initialize(initial_fill = true)
    @board = Array.new(8) { Array.new(8) }
    set_board(initial_fill)
  end

  def set_board(initial_fill)
    return unless initial_fill
    [:red, :white].each { |color| fill_rows(color); fill_midrows(color) }
  end

  def fill_rows(color)
    i = color == :red ? [0,2] : [5, 7]
    i.each do |row|
      8.times do |col|
        next if col.even? && color == :red
        next if col.odd? && color == :white
        pos = [row, col]
        self[pos] = Piece.new(self, color, pos)
      end
    end
  end

  def fill_midrows(color)
    row = color == :red ? 1 : 6

    8.times do |col|
      next if col.odd? && color == :red
      next if col.even? && color == :white
      pos = [row, col]
      self[pos] = Piece.new(self, color, pos)
    end

  end

  def display
    print " "; 8.times { |num| print "  #{num}".colorize(:magenta)}; puts ""
    board.each_with_index do |row, index|
      print "#{index} ".colorize(:magenta)
      col = 0
      row.each do |piece|
        color = (index.even? && col.odd?) || (index.odd? && col.even?) ? :black : :light_blue
        print piece.is_a?(Piece) ? " #{piece.to_s.colorize(:background => color)} " : "   ".colorize(:background => color)
        col += 1
      end
      puts ""
    end
    puts "\n---------------------------------"
  end

  def dup
    dup_board = Board.new(false)
    pieces.each { |piece| Piece.new(dup_board, piece.color, piece.pos) }
    dup_board
  end

  def pieces
    board.flatten.select { |el| el.is_a?(Piece) }
  end

  def add_piece(piece, pos)
    self[pos] = piece
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
    return false unless valid_pos?(pos)

    self[pos].is_a?(Piece) && self[pos].color != color
  end

end


b = Board.new
b.display

p = Piece.new(b, :red, [2,1])

p.perform_slide([3,2])
b.display

whi1 = Piece.new(b, :white, [5,4])
whi1.perform_slide([4,3])
b.display

p3 = b[[2,5]]
puts "red p3 pos: #{p3.pos}, slide moves: #{p3.slide_moves}, jump moves: #{p3.jump_moves}"
p3.perform_slide([3,4])
b.display
puts "white pos: #{whi1.pos}, slide moves: #{whi1.slide_moves}, jump moves: #{whi1.jump_moves}"

red4 = b[[1,4]]
red4.perform_slide([2,5])
b.display

red3 = b[[0,3]]
red3.perform_slide([1,4])
b.display

 # whi1.perform_jump([2,1])
 # b.display
# puts "white pos: #{whi1.pos}, slide moves: #{whi1.slide_moves}, jump moves: #{whi1.jump_moves}"
#
# whi1.perform_jump([0,3])
# b.display

p whi1.valid_move_seq?([2,1],[4,4])

#whi1.perform_moves([2,1],[0,3])
puts "original: "
b.display




# puts "red pos: #{p.pos}, slide moves: #{p.slide_moves}, jump moves: #{p.jump_moves}"
# p2.perform_jump([2,1])
# b.display

