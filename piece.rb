require 'colorize'


class Piece
  attr_accessor :board, :color, :pos

  def initialize(board, color, pos)
    @board = board
    @color = color
    @pos = pos
  end

  def slide_moves
    slide_moves = []
    slide_move_dirs.each do |dx, dy|
      cur_x, cur_y = pos
      pos = [cur_x + dx, cur_y + dy]

      next unless board.valid_pos?(pos)
      slide_moves << pos unless board[pos].nil?
    end
    slide_moves
  end

  def jump_moves
    jump_moves = []
    jump_move_dirs.each do |dx, dy|
      cur_x, cur_y = pos
      pos = [cur_x + dx, cur_y + dy]

      next unless board.valid_pos?(pos)
      jump_moves << pos if board.opponent?(pos, color)

    end
    jump_moves
  end

  def perform_slide
  end

  def perform_jump
  end

  def slide_move_dirs       #consolidate jump_moves and slide_moves
    if color == :red
      [[1,-1], [1,1]]
    else
      [[-1,-1], [-1,1]]
    end
  end

  def jump_move_dirs
    if color == :red
      [[2,-2], [2,2]]
    else
      [[-2,-2], [-2,2]]
    end
  end

  def to_s
    "#{color[0..2].upcase}".colorize(color)
  end
end

class KingPiece < Piece
end

