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

  def move(pos, target_pos)
    begin
      self[pos].perform_slide(target_pos)
    rescue
      if self[pos].valid_move_seq?(target_pos)
        self[pos].perform_moves!(target_pos)
      end
      return true #return true if jump move
    end
  end

  def jump(pos, target_pos)
    self[pos].perform_moves!(target_pos)
    must_jump?(target_pos)
  end

  def must_jump?(pos)
    p self[pos].jump_moves
    !self[pos].jump_moves.empty?
  end

  def dup
    dup_board = Board.new(false)
    pieces.each { |piece| Piece.new(dup_board, piece.color, piece.pos) }
    dup_board
  end

  def pieces
    board.flatten.select { |el| el.is_a?(Piece) }
  end

  def more_moves?
    pieces.any? { |piece| !piece.slide_moves.empty? || !piece.jump_moves.empty? }
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
