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


class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end
  
  def lizard?
    @value == 'lizard'
  end
  
  def spock?
    @value == 'spock'
  end

  def >(other_move)
    (rock? && (other_move.scissors? || other_move.lizard?)) ||
      (paper? && (other_move.rock? || other_move.spock?)) ||
      (scissors? && (other_move.paper? || other_move.lizard?)) ||
      (lizard? && (other_move.paper? || other_move.spock?)) ||
      (spock? && (other_move.rock? || other_move.scissors?))
  end

  def <(other_move)
    (rock? && (other_move.paper? || other_move.spock?)) ||
      (paper? && (other_move.scissors? || other_move.lizard?)) ||
      (scissors? && (other_move.rock? || other_move.spock?)) ||
      (lizard? && (other_move.rock? || other_move.scissors?)) ||
      (spock? && (other_move.paper? || other_move.lizard?))
  end

  def to_s
    @value
  end
end

class Rock < Move
  
end

class Paper < Move
  
end

class Scissors < Move
  
end

class Lizard < Move
  
end

class Spock < Move
  
end

class Rule
  def initialize
    # not sure what the "state" of a rule object should be
  end
end

# not sure where "compare" goes yet
def compare(move1, move2); end

class Player
  attr_accessor :move, :name, :score
  
  WINNING_SCORE = 5
  
  def initialize
    set_name
    @score = 0
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
      puts "Please choose rock, paper, scissors, lizard, or spock:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['Reggie', 'CiCi', 'Sonia', 'Dash', 'Turbo'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

# Game Orchestration Engine
class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Good bye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
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
  
  def keep_score
    if human.move > computer.move
      human.score += 1
    elsif human.move < computer.move
      computer.score += 1
    else
    end
  end
  
  def display_score
    puts "Score"
    puts "-----"
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
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
      system 'clear'
      human.choose
      computer.choose
      display_moves
      display_winner
      keep_score
      display_score
      if champion?
        declare_champion
        break
      end
      break unless play_again?
    end
    
    display_goodbye_message
  end
end

RPSGame.new.play
