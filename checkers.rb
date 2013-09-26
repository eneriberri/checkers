require 'colorize'

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

      self.board[row][col] = Piece.new(self.board, color, [row, col])
    end

  end

  def display
    board.each do |row|
      row.each do |piece|
        p piece.to_s + " "
      end
      puts ""
    end
  end

  def [](pos)
    row, col = pos
    board[row][col]
  end

  def []=(pos, val)
    row, col = pos
    board[row][col] = val
  end

end

class Piece
  attr_accessor :board, :color, :pos

  def initialize(board, color, pos)
    @board = board
    @color = color
    @pos = pos
  end

  def move

  end

  def to_s
    "#{color}"
  end
end

class KingPiece < Piece
end

b = Board.new
#b.display
p b.board