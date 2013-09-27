require 'colorize'

class Piece
  attr_accessor :board, :color, :pos

  def initialize(board, color, pos)
    @board, @color, @pos = board, color, pos
    board.add_piece(self, pos)
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

      if board.opponent?(pos, color)
        cur_x, cur_y = pos
        pos = [cur_x + dx, cur_y + dy]
        next unless board.valid_pos?(pos)
        jump_moves << pos
      end
    end
    jump_moves
  end

  def perform_slide(target_pos)
    raise InvalidMoveError unless slide_moves.include? target_pos

    board[pos] = nil
    self.pos = target_pos
    board[pos] = self
    promote(target_pos) if promote?
  end

  def perform_jump(target_pos)
    raise InvalidMoveError unless jump_moves.include? target_pos

    cur_x, cur_y = target_pos
    prior_x, prior_y = pos
    diff = [cur_x - prior_x, cur_y - prior_y]
    jumped_x, jumped_y = diag_dirs(diff)

    jumped_loc = [prior_x + jumped_x, prior_y + jumped_y]
    board[pos] = nil
    board[jumped_loc] = nil
    self.pos = target_pos
    board[pos] = self
    promote(target_pos) if promote?
  end

  def perform_moves!(*moves)
    moves.each { |move| self.perform_jump(move) } #; self.board.display }
  end

  # def perform_moves(*moves)
  #   dup_board = board.dup
  #   dup_piece = Piece.new(dup_board, self.color, self.pos)
  #   moves.each { |move| dup_piece.perform_jump(move); dup_board.display }
  # end

  def valid_move_seq?(*moves)
    dup_board = board.dup
    dup_piece = Piece.new(dup_board, self.color, self.pos)
    begin
      moves.each { |move| dup_piece.perform_moves!(move) }
    rescue InvalidMoveError
      return false
    end
    true
  end

  def to_s
    "\u2B24".colorize(color)
  end

  def promote?
    row = pos[0]
    (color == :red && row == 7) || (color == :white && row == 0)
  end

  def promote(target_pos)
    board[target_pos] = KingPiece.new(board, color, target_pos)
    # self.board, self.pos, self.color = nil, nil, nil #remove original piece
  end

  private
  def diag_dirs(diff)
    case diff
    when [-2, -2] #upper left diag
      [-1, -1]
    when [-2, 2] #upper right diag
      [-1, 1]
    when [2, -2] #lower left diag
      [1, -1]
    when [2, 2] #lower right diag
      [1, 1]
    end
  end

  def move_dirs
    if color == :red
      [[1,-1], [1,1]]
    else
      [[-1,-1], [-1,1]]
    end
  end

end


class KingPiece < Piece
  def initialize(board, color, pos)
    @board, @color, @pos = board, color, pos
    board.add_piece(self, pos)
  end

  def move_dirs
    [[1,-1], [1,1], [-1,-1], [-1,1]]
  end

  #white pieces when king are yellow. red are magenta.
  def to_s
    display_color = color == :red ? :magenta : :yellow
    "\u2B24".colorize(display_color)
  end

end

class InvalidMoveError < ArgumentError
end

