require 'pry'
require 'io/console'
require 'timeout'

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

class Slowpoke < Move
  def > other
    false
  end
  
  def < other
    true
  end
end

class Player
  attr_accessor :name, :move, :score, :move_2
  
  def initialize
    set_name
  end
  
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "To begin, type your name:"
      n = gets.chomp
      if n.empty?
        puts "Sorry, please enter a value."
      elsif n.length > 15
        puts "Sorry, please enter a shorter name."
      else
        break
      end
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
  
  def choose_dash
    choice = nil
    
    begin
      Timeout::timeout(3) do
        loop do
          puts "Quick! r, p, s, l, or sp:"
          choice = gets.chomp.downcase
          break if %w(rock r paper p scissors s lizard l spock sp).include?(choice)
          puts "Sorry, invalid choice."
        end
      end
    rescue Timeout::Error
      choice = "timeout"
    end
    
    self.move = set_move(choice)
  end
  
  def choose_turbo
    choice_1 = nil
    choice_2 = nil
    self.move = Slowpoke.new
    options = %w(rock r paper p scissors s lizard l spock sp)

    begin
      Timeout::timeout(5) do
        loop do
          puts "Quick, enter twice! r, p, s, l, or sp:"
          choice_1 = gets.chomp.downcase
          break if options.include?(choice_1)
          puts "Sorry, invalid choice."
        end
        
        self.move = set_move(choice_1)
        
        loop do
          choice_2 = gets.chomp.downcase
          break if options.include?(choice_2)
          puts "Sorry, invalid choice."
        end
      end
    rescue Timeout::Error
      choice_1 = "timeout 1"
      choice_2 = "timeout 2"
    end

    self.move_2 = set_move(choice_2)
  end
  
  def set_move(choice)
    case choice
    when 'rock', 'r'
      Rock.new
    when 'paper', 'p'
      Paper.new
    when 'scissors', 's'
      Scissors.new
    when 'lizard', 'l'
      Lizard.new
    when 'spock', 'sp'
      Spock.new
    else
      Slowpoke.new
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
  def to_s
    "#{name} plays old fashioned RPSLS."
  end
end

class Cici < Computer
  def choose(move_history)
    probability = [1, 2, 3, 4, 5].sample
    if probability >= 4 || move_history.empty?
      self.move = [Rock.new, Paper.new, Scissors.new, Lizard.new, Spock.new].sample
    else
      self.move = move_history.values.last[0]
    end
  end
  
  def to_s
    "#{name} has a tendency to copy your moves."
  end
end

class Sonia < Computer
  def choose(move_history)
    probability = [1, 2, 3, 4, 5].sample
    if probability >= 4 || move_history.empty?
      self.move = [Rock.new, Paper.new, Scissors.new, Lizard.new, Spock.new].sample
    else
      if move_history.values.last[2] == "Lost"
        winning_move = move_history.values.last[1]
      else
        winning_move = move_history.values.last[0]
      end
      new_move = [Rock.new, Paper.new, Scissors.new, Lizard.new, Spock.new].sample
      until new_move > winning_move do
        new_move = [Rock.new, Paper.new, Scissors.new, Lizard.new, Spock.new].sample
      end
      self.move = new_move
    end
  end
  
  def to_s
    "#{name} likes to play a winner over the previous hand."
  end
end

class Dash < Computer
  def to_s
    "#{name} forces you to answer quickly or lose."
  end
end

class Turbo < Computer
  def choose
    super
    self.move_2 = [Rock.new, Paper.new, Scissors.new, Lizard.new, Spock.new].sample
  end
  
  def to_s
    "#{name} plays two hands. Win both to win. Lose one and you lose. Everything else is a tie."
  end
end

class Round
  attr_accessor :number, :wins, :losses, :ties, :result, :history, :history2
  
  WINNING_SCORE = 5
  
  def initialize
    @number = 0
    @wins = 0
    @losses = 0
    @ties = 0
    @result = nil
    @history = {}
    @history2 = {}
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

  def display_history
    puts history
    # history.values.each do |round|
    #   puts "#{round[0]} / #{round[1]} / #{round[2]} / #{round[3]}"
    # end
  end
  
  def champion?
    score = Round::WINNING_SCORE
    return true if computer.score == score || human.score == score
    false
  end
  
  def declare_champion
    if human.score == Round::WINNING_SCORE
      puts "#{human.name} is the champion!"
    else
      puts "#{computer.name} is the champion!"
    end
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Good bye!"
  end
end

class Game
  attr_accessor :human, :computer, :round

  def display_welcome_message
    puts "------------------------------------------------"
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
    puts "------------------------------------------------"
  end

  def display_instructions
    puts "GAME RULES".center(48)
    puts "------------------------------------------------"
    puts "    Scissors cuts Paper covers Rock crushes"
    puts "    Lizard poisons Spock smashes Scissors"
    puts "    decapitates Lizard eats Paper disproves"
    puts "    Spock vaporizes Rock crushes Scissors"
    puts
  end
  
  def set_screen
    system 'clear'
    display_welcome_message
    display_instructions
  end
  
  def choose_game_mode
    system 'clear'
    puts "Hi, #{human.name}!"
    puts "Choose game mode:"
    puts "=> Practice (p) - Test your skills against one of five opponents."
    puts
    puts "=> Tournament (t) - Defeat all five opponents to become Champion!"
    puts
    puts "=> Quit (q)"
    mode = ""
    loop do
      mode = gets.chomp.downcase
      break if ['p', 'practice', 't', 'tournament'].include?(mode)
      puts "Please choose either Practice (p) or Tournament (t)."
    end
    
    practice if mode == 'p' || mode == 'practice'
    tournament if mode == 't' || mode == 'tournament'
  end
  
  def practice_welcome
    @round = Round.new
    
    system 'clear'
    puts "Welcome to Practice Mode. Choose any of the five opponents to begin:"
    puts
    puts "=> #{Reggie.new}"
    puts "=> #{Cici.new}"
    puts "=> #{Sonia.new}"
    puts "=> #{Dash.new}"
    puts "=> #{Turbo.new}"
    puts
  end
  
  def tournament_welcome
    @round = Round.new
    
    system 'clear'
    puts "Welcome to the Tournament."
    puts "You will face all 5 opponents in succession:"
    puts "=> #{Reggie.new}"
    puts "=> #{Cici.new}"
    puts "=> #{Sonia.new}"
    puts "=> #{Dash.new}"
    puts "=> #{Turbo.new}"
    puts "Win #{Round::WINNING_SCORE} rounds before your opponent to advance."
    puts "Defeat all 5 opponents to become RPSLS Champion!"
    
    puts "Start (enter) / Quit (q)"
    
  end
  
  def choose_opponent
    opp = ""
    loop do
      puts "Choose opponent: Reggie (r), Cici (c), Sonia (s), Dash (d), or Turbo (t)"
      opp = gets.chomp.downcase
      break if %w(reggie r cici c sonia s Dash d turbo t).include?(opp)
      puts "Sorry, please choose a valid opponent."
    end
    
    case opp
    when 'reggie', 'r'
      Reggie.new
    when 'cici', 'c'
      Cici.new
    when 'sonia', 's'
      Sonia.new
    when 'Dash', 'd'
      Dash.new
    when 'turbo', 't'
      Turbo.new
    end
  end
  
  def opponent_message
    puts "Your opponent is #{computer.name}!"
    puts
    puts computer
    puts
    puts "Good luck! Press any key to continue."
    STDIN.getch
  end
  
  def set_round_screen
    system 'clear'
    display_instructions
    display_history
    display_score
  end
  
  def set_round_screen_turbo
    system 'clear'
    display_instructions
    display_history_turbo
    display_score
  end
  
  def display_history
    spaces = " " * ((37 - human.name.length - computer.name.length) / 3)
    puts "MOVE HISTORY".center(48)
    puts "Round#{spaces}#{human.name}#{spaces}#{computer.name}#{spaces}Result"
    puts "------------------------------------------------"
    round.history.each do |key, value|
      sp1 = " " * (5 + spaces.length - key.to_s.length)
      sp2 = " " * (human.name.length + spaces.length - value[0].to_s.length)
      sp3 = " " * (computer.name.length + spaces.length - value[1].to_s.length)
      puts "#{key}#{sp1}#{value[0]}#{sp2}#{value[1]}#{sp3}#{value[2]}"
    end
    puts
  end
  
  def display_history_turbo
    space1 = " " * (18 - human.name.length)
    space2 = " " * (18 - computer.name.length)
    puts "MOVE HISTORY".center(48)
    puts "Round #{human.name}#{space1}#{computer.name}#{space2}Result"
    puts "------------------------------------------------"
    round.history2.each do |key, value|
      sp1 = " " * (6 - key.to_s.length)
      sp2 = " " * (17 - value[0].to_s.length - value[1].to_s.length)
      sp3 = " " * (17 - value[2].to_s.length - value[3].to_s.length)
      puts "#{key}#{sp1}#{value[0]}/#{value[1]}#{sp2}#{value[2]}/#{value[3]}#{sp3}#{value[4]}"
    end
    puts
  end
  
  def display_score
    h = human.name.length
    c = computer.name.length
    w = round.wins.to_s.length
    l = round.losses.to_s.length
    t = round.ties.to_s.length
    constant = 10
    spaces = " " * ((48 - (constant + h + c + w + l + t)) / 4)
    puts "SCORE".center(48)
    puts "------------------------------------------------"
    puts "#{spaces}#{human.name}: #{round.wins}#{spaces}#{computer.name}: " +
    "#{round.losses}#{spaces}Ties: #{round.ties}#{spaces}"
    puts
  end
  
  def display_moves
    puts "#{computer.name} chose #{computer.move}."
    puts "#{human.name} chose #{human.move}."
    puts
  end
  
  def display_dash_move
    puts "#{computer.name} chose #{computer.move}."
    puts
  end
  
  def display_turbo_move
    puts "#{computer.name} chose #{computer.move} and #{computer.move_2}."
    puts
  end
  
  def display_turbo_moves
    puts "#{computer.name} chose #{computer.move} and #{computer.move_2}."
    puts "#{human.name} chose #{human.move} and #{human.move_2}."
    puts
  end
  
  def determine_result
    if human.move > computer.move
      round.result = "Won"
    elsif human.move < computer.move
      round.result = "Lost"
    else
      round.result = "Tied"
    end
  end
  
  def determine_result_turbo
    if human.move > computer.move && human.move_2 > computer.move_2
      round.result = "Won"
    elsif human.move < computer.move || human.move_2 < computer.move_2
      round.result = "Lost"
    else
      round.result = "Tied"
    end
  end
  
  def tally_score
    round.number += 1
    if human.move > computer.move
      round.wins += 1
    elsif human.move < computer.move
      round.losses += 1
    else
      round.ties += 1
    end
  end
  
  def tally_score_turbo
    round.number += 1
    if human.move > computer.move && human.move_2 > computer.move_2
      round.wins += 1
    elsif human.move < computer.move || human.move_2 < computer.move_2
      round.losses += 1
    else
      round.ties += 1
    end
  end
  
  def record_moves
    round.history[round.number] = [human.move, computer.move, round.result]  
  end
  
  def record_moves_turbo
    round.history2[round.number] = [human.move, human.move_2, computer.move, computer.move_2, round.result]
  end
  
  def display_winner
    if round.result == "Won"
      puts "#{human.name} won!"
    elsif round.result == "Lost"
      puts "#{computer.name} won."
    else
      puts "It's a tie."
    end
    puts
  end
  
  def champion
    score = Round::WINNING_SCORE
    return "human" if round.wins == score
    return "computer" if round.losses == score
    "none"
  end
  
  def continue_prompt
    answer = nil
    loop do
      puts "Continue (enter) / Change Opponent (c) / Quit Practice (q)"
      answer = gets
      if answer == "\n"
        return "continue"
      elsif answer.chomp.downcase == 'c'
        return "change opponent"
      elsif answer.chomp.downcase == 'q'
        return "quit"
      else
        puts "Sorry, invalid response."
      end
    end
  end
  
  def play_reggie
    set_round_screen
    computer.choose
    human.choose
    set_round_screen
    display_moves
    determine_result
    tally_score
    record_moves
    set_round_screen
    display_moves
    display_winner
  end
  
  def play_cici
    set_round_screen
    computer.choose(round.history)
    human.choose
    set_round_screen
    display_moves
    determine_result
    tally_score
    record_moves
    set_round_screen
    display_moves
    display_winner
  end
  
  def play_sonia
    set_round_screen
    computer.choose(round.history)
    human.choose
    set_round_screen
    display_moves
    determine_result
    tally_score
    record_moves
    set_round_screen
    display_moves
    display_winner
  end
  
  def play_dash
    set_round_screen
    computer.choose
    display_dash_move
    human.choose_dash
    set_round_screen
    determine_result
    tally_score
    record_moves
    set_round_screen
    display_moves
    display_winner
  end
  
  def play_turbo
    set_round_screen_turbo
    computer.choose
    display_turbo_move
    human.choose_turbo
    set_round_screen_turbo
    determine_result_turbo
    tally_score_turbo
    record_moves_turbo
    set_round_screen_turbo
    display_turbo_moves
    display_winner
  end
  
  def practice
    practice_welcome
    @computer = choose_opponent
    system 'clear'
    opponent_message
    loop do
      case computer.name
      when "Reggie"
        play_reggie
      when "Cici"
        play_cici
      when "Sonia"
        play_sonia
      when "Dash"
        play_dash
      when "Turbo"
        play_turbo
      end
      decision = continue_prompt
        if decision == "change opponent"
          return practice
        elsif decision == "quit"
          return choose_game_mode
        elsif decision == "continue"
          next
        end
    end
  end
  
  def tournament
    tournament_welcome
    @computer = Reggie.new
    opponent_message
    loop do
      play_reggie
      continue_prompt
      if champion == "human"
        puts "Congrats! Moving to next opponent."
        break
      elsif champion == "computer"
        puts "Sorry, better luck next time."
        return
      end
    end
    @round = Round.new
    @computer = Cici.new
    opponent_message
    loop do
      play_cici
      continue_prompt
      if champion == "human"
        puts "Congrats! Moving to next opponent."
        break
      elsif champion == "computer"
        puts "Sorry, better luck next time."
        return
      end
    end
    @round = Round.new
    @computer = Sonia.new
    opponent_message
    loop do
      play_sonia
      continue_prompt
      if champion == "human"
        puts "Congrats! Moving to next opponent."
        break
      elsif champion == "computer"
        puts "Sorry, better luck next time."
        return
      end
    end
    @round = Round.new
    @computer = Dash.new
    opponent_message
    loop do
      play_dash
      continue_prompt
      if champion == "human"
        puts "Congrats! Moving to next opponent."
        break
      elsif champion == "computer"
        puts "Sorry, better luck next time."
        return
      end
    end
    @round = Round.new
    @computer = Turbo.new
    opponent_message
    loop do
      play_turbo
      continue_prompt
      if champion == "human"
        puts "Congrats! Moving to next opponent."
        break
      elsif champion == "computer"
        puts "Sorry, better luck next time."
        return
      end
    end
    puts "Congrats! You are the Champion!"
  end
  
  def start
    set_screen
    @human = Human.new
    choose_game_mode
  end
end

Game.new.start
