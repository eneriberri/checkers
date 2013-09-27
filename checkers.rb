require_relative 'board'
require_relative 'piece'

class Game
  attr_accessor :b, :red

  def initialize
    @b = Board.new
    @red = true
    play
  end

  def play
    intro
    game_over = false
    until game_over
      make_turn(red)
      b.display
      self.red = !red
      game_over = game_over?
    end
  end

  def intro
    puts "Welcome to Checkers!"
    puts "Red moves first."
    b.display
  end

  def make_turn(red)
    begin
      player = red ? "Red" : "White"
      puts "#{player}, select piece: (e.g. 1,0)"
      pos = gets.chomp.split(",").map(&:to_i)

      puts "#{player}, select destination: "
      target_pos = gets.chomp.split(",").map(&:to_i)
      jump = b.move(pos, target_pos)
      continue_jump(target_pos, red) if jump
    rescue
      puts "Invalid move. Try again."
      retry
    end


  end

  def continue_jump(new_pos, red)
    # "puts inside continue_jump method"
    # p "#{new_pos} :new_pos"
    if b.must_jump?(new_pos)
      puts "You must jump."
      b.display
      jump_turn(new_pos, red)
    end
  end

  def jump_turn(new_pos, red)
    begin
      player = red ? "Red" : "White"
      puts "#{player}, select piece: (e.g. 1,0)"
      pos = gets.chomp.split(",").map(&:to_i)

      puts "#{player}, select destination: "
      target_pos = gets.chomp.split(",").map(&:to_i)
      jump = b.move(pos, target_pos)
      continue_jump(target_pos, red) if jump
    rescue
      puts "Invalid move. Try again."
      retry
    end
  end



  def game_over?
    b.board.flatten.compact.empty?
  end
end

Game.new