require 'colorize'

class Board
  attr_accessor :board

  def initialize
    @board = Array.new(8) { Array.new(8) }
    set_board
  end

  def set_board
    [:red, :white].each { fill_rows }
  end

  def fill_rows
    i = color == :red ? 0 : 6
    8.times do |j|
      next if j.even? && color == :red
      next if j.odd? && color == :white

      self.board[i][j] = Piece.new(self.board, color, [i, j])
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
end

class KingPiece < Piece
end