=begin
Features to add:
1. add lizard, spock
2. keep score
3. add class for each move
4. keep history
5. robot personalities

Scissors cuts Paper covers Rock crushes Lizard poisons Spock smashes Scissors decapitates Lizard eats Paper disproves Spock vaporizes Rock crushes Scissors

Move	    Win	                Lose
Rock	    Scissors, Lizard 	  Paper, Spock
Paper	    Rock, Spock	        Scissors, Lizard
Scissors	Paper, Lizard	      Rock, Spock
Lizard	  Paper, Spock	      Rock, Scissors
Spock	    Rock, Scissors	    Paper, Lizard

5 Robots each with a different tendency:
1. Reggie - traditional RPSLS
2. CiCi - 80% tends to choose what you chose before
3. Sonia - 80% tends to choose a winner over the last winning hand
4. Dash - reveals the hand and gives you 2 seconds to beat it
5. Turbo - reveals two hands and gives you 3 seconds to beat both
=end
require 'pry'
class Move
  attr_accessor :name
  
  def initialize
    @name = self.class.to_s
  end
  
  def to_s
    name
  end
end

class Rock < Move
  def > other
    other.class == Scissors || other.class == Lizard
  end
  
  def < other
    other.class == Paper || other.class == Spock
  end
end

class Paper < Move
  def > other
    other.class == Rock || other.class == Spock
  end
  
  def < other
    other.class == Scissors || other.class == Lizard
  end
end

class Scissors < Move
  def > other
    other.class == Paper || other.class == Lizard
  end
  
  def < other
    other.class == Rock || other.class == Spock
  end
end

class Lizard < Move
  def > other
    other.class == Paper || other.class == Spock
  end
  
  def < other
    other.class == Rock || other.class == Scissors
  end
end

class Spock < Move
  def > other
    other.class == Rock || other.class == Scissors
  end
  
  def < other
    other.class == Paper || other.class == Lizard
  end
end

class Rule
  def initialize
    # not sure what the "state" of a rule object should be
  end
end

# not sure where "compare" goes yet
def compare(move1, move2); end

class Player
  attr_accessor :move, :name, :score, :history
  
  WINNING_SCORE = 5
  
  def initialize
    set_name
    @score = 0
    @history = []
  end
  
  def store(move)
    history << move
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end
  
  def choose
    choice = nil
    loop do
      puts "Please choose rock (r), paper (p), scissors (s), lizard (l), or spock (sp):"
      choice = gets.chomp.downcase
      break if %w(rock r paper p scissors s lizard l spock sp).include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = set_move(choice)
  end
  
  def set_move(choice)
    case choice
    when 'rock'
      Rock.new
    when 'paper'
      Paper.new
    when 'scissors'
      Scissors.new
    when 'lizard'
      Lizard.new
    when 'spock'
      Spock.new
    when 'r'
      Rock.new
    when 'p'
      Paper.new
    when 's'
      Scissors.new
    when 'l'
      Lizard.new
    when 'sp'
      Spock.new
    end
  end
end

class Computer < Player
  def set_name
    self.name = ['Reggie', 'Cici', 'Sonia', 'Speedy', 'Turbo'].sample
  end

  def choose
    self.move = [Rock.new, Paper.new, Scissors.new, Lizard.new, Spock.new].sample
  end
end
# Five Robots each with a different tendency:
# 1. Reggie - traditional RPSLS
# 2. CiCi - 80% tends to choose what you chose before
# 3. Sonia - 80% tends to choose a winner over the last winning hand
# 4. Dash - reveals the hand and gives you 2 seconds to beat it
# 5. Turbo - reveals two hands and gives you 3 seconds to beat both
class Reggie < Computer
  
end

class Cici < Computer
  
end

class Sonia < Computer
  
end

class Speedy < Computer
  
end

class Turbo < Computer
  
end

# Game Orchestration Engine
class RPSLSGame
  attr_accessor :human, :computer, :round, :wins, :losses, :ties, :result, :history

  def initialize
    @human = Human.new
    @computer = Computer.new
    @round = 0
    @wins = 0
    @losses = 0
    @ties = 0
    @result = nil
    @history = {}
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Good bye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end
  
  def score
    self.round += 1
    if human.move > computer.move
      self.wins += 1
      self.result = "Won"
    elsif human.move < computer.move
      self.losses += 1
      self.result = "Lost"
    else
      self.ties += 1
      self.result = "Tied"
    end
  end
  
  def record_history
    self.history[round] = [human.move, result, computer.move]  
  end
  
  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won."
    else
      puts "It's a tie."
    end
  end
  
  def display_score
    puts "Score"
    puts "-----"
    puts "#{human.name}: #{wins}"
    puts "#{computer.name}: #{losses}"
    puts "Ties: #{ties}"
  end
  
  def display_history
    history.values.each do |round|
      puts "#{round[0]} / #{round[1]} / #{round[2]}"
    end
  end
  
  def champion?
    score = Player::WINNING_SCORE
    return true if computer.score == score || human.score == score
    false
  end
  
  def declare_champion
    if human.score == Player::WINNING_SCORE
      puts "#{human.name} is the champion!"
    else
      puts "#{computer.name} is the champion!"
    end
  end
  
  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts "Sorry, must be y or n."
    end

    return true if answer == 'y'
    false
  end

  def play
    display_welcome_message

    loop do
      system 'clear' # set board method
      human.choose
      computer.choose
      display_moves
      score
      record_history
      display_winner
      display_score
      display_history
      if champion?
        declare_champion
        break
      end
      break unless play_again?
    end
    
    display_goodbye_message
  end
end

RPSLSGame.new.play
