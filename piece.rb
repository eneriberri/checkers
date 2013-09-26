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
    move_dirs.each do |dx, dy|
      cur_x, cur_y = pos
      pos = [cur_x + dx, cur_y + dy]

      next unless board.valid_pos?(pos)
      slide_moves << pos if board[pos].nil?
    end
    slide_moves
  end

  def jump_moves
    jump_moves = []
    move_dirs.each do |dx, dy|
      cur_x, cur_y = pos
      pos = [cur_x + dx, cur_y + dy]

      next unless board.valid_pos?(pos)
      if board.opponent?(pos, color)
        cur_x, cur_y = pos
        pos = [cur_x + dx, cur_y + dy]
        jump_moves << pos
      end
    end
    jump_moves
  end

  def perform_slide(target_pos)
    raise "InvalidMoveError" unless slide_moves.include? target_pos

    board[pos] = nil
    self.pos = target_pos
    board[pos] = self
  end

  def perform_jump(target_pos)
    raise "InvalidMoveError" unless jump_moves.include? target_pos

    cur_x, cur_y = target_pos
    prior_x, prior_y = pos
    board[pos] = nil

    #find pos of jumped piece
    diff = [cur_x - prior_x, cur_y - prior_y]
    jumped_loc_x, jumped_loc_y = case diff
    when [-2, -2] #upper left diag
      [-1, -1]
    when [-2, 2] #upper right diag
      [-1, 1]
    when [2, -2] #lower left diag
      [1, -1]
    when [2, 2] #lower right diag
      [1, 1]
    end

    jumped_loc = [prior_x + jumped_loc_x, prior_y + jumped_loc_y]
    board[jumped_loc] = nil

    self.pos = target_pos
    board[pos] = self

    #set it's loc to nil, and nil the board at that loc
  end

  def move_dirs       #consolidate jump_moves and slide_moves
    if color == :red
      [[1,-1], [1,1]]
    else
      [[-1,-1], [-1,1]]
    end
  end

  # def jump_move_dirs
  #   if color == :red
  #     [[2,-2], [2,2]]
  #   else
  #     [[-2,-2], [-2,2]]
  #   end
  # end

  def to_s
    "#{color[0..2].upcase}".colorize(color)
  end
end

class KingPiece < Piece
end

