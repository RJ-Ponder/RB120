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

class Player
  attr_accessor :name, :move, :score
  
  def initialize
    set_name
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
    self.name = self.class.to_s
  end

  def choose
    self.move = [Rock.new, Paper.new, Scissors.new, Lizard.new, Spock.new].sample
  end
end

class Reggie < Computer
  
end

class Cici < Computer
  def choose
    probability = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].sample
    if probability >= 9
      self.move = [Rock.new, Paper.new, Scissors.new, Lizard.new, Spock.new].sample
    else
      self.move = human.history[RPSLSGame.round][0]
    end
  end
end

class Sonia < Computer
  
end

class Speedy < Computer
  
end

class Turbo < Computer
  
end

class Score
  attr_accessor :round, :wins, :losses, :ties, :result, :history
  
  WINNING_SCORE = 5
  
  def initialize
    @round = 0
    @wins = 0
    @losses = 0
    @ties = 0
    @result = nil
    @history = {}
  end
end

class Game
  attr_accessor :human, :computer, :score

  def initialize
    @human = Human.new
    @computer = choose_opponent
    @score = Score.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Good bye!"
  end
  
  def choose_opponent
    n = ""
    loop do
      puts "Choose opponent: Reggie, Cici, Sonia, Speedy, or Turbo"
      n = gets.chomp.downcase
      break if %w(reggie cici sonia speedy turbo).include?(n)
      puts "Sorry, please choose a valid opponent."
    end
    
    case n
    when 'reggie'
      Reggie.new
    when 'cici'
      Cici.new
    when 'sonia'
      Sonia.new
    when 'speedy'
      Speedy.new
    when 'turbo'
      Turbo.new
    end
  end
  
  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end
  
  def keep_score
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
    self.history[round] = [round, human.move, result, computer.move]  
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
      puts "#{round[0]} / #{round[1]} / #{round[2]} / #{round[3]}"
    end
  end
  
  def champion?
    score = Score::WINNING_SCORE
    return true if computer.score == score || human.score == score
    false
  end
  
  def declare_champion
    if human.score == Score::WINNING_SCORE
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
      keep_score
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

Game.new.play

=begin
Gameplay
Welcome - Welcome to Rock, Paper, Scissors, Lizard, Spock!
Instructions - Scissors cuts Paper covers Rock crushes Lizard
               poisons Spock smashes Scissors decapitates Lizard
               eats Paper disproves Spock vaporizes Rock crushes Scissors
Human - To begin, type your name.
Message - Hi human! Choose game mode:
                    Practice (p) - Test your skills on any of the five opponents.
                    Tournament (t) - Defeat all five opponents to become Champion!
Practice
Message - Welcome to practice. Choose any of the five opponents to begin.
            Reggie - good ol' fashioned RPSLS
            Cici - she has a tendency to copy
            Sonia - she has a tendency to play a winner over the previous hand
            Speedy - answer a single hand quickly or you lose
            Turbo - answer two hands quickly or you lose
Opponent - select
Reggie play
  set board
  display last 5 moves -              LAST 5 MOVES
                          Round    Human      Computer    Result
                          --------------------------------------
                          (1)      Rock       Spock       Won
                          (2)      Paper      Lizard      Lost
                          (3)      Scissors   Scissors    Tied
                          
  display current score -                 SCORE
                          Human: 1     Computer: 1      Ties: 1
  
  human.choose
  computer.choose
  display human choice
  display computer choice
  display winner
  play_again?
  
  Choose Rock (r), Paper (p), Scissors (s), Lizard (l), or Spock (sp)
    Human chose [choice]
    Computer chose [choice]
  
    You won that round
    Computer won that round
    It's a tie
  
  Continue Practicing (c) / Switch Opponent (s) / Quit Practice (q)
  
  
  update score
  log history
  
  
Cici play
Sonia play
Speedy play
Turbo play

=end
