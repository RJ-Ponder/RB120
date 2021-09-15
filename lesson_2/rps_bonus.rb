require 'io/console'
require 'timeout'

module Displayable
  SCREEN_WIDTH = 62

  def center(message)
    puts message.center(SCREEN_WIDTH)
  end

  def center_break(message)
    puts message.center(SCREEN_WIDTH)
    puts
  end
end

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
  def >(other)
    other.class == Scissors || other.class == Lizard
  end

  def <(other)
    other.class == Paper || other.class == Spock
  end
end

class Paper < Move
  def >(other)
    other.class == Rock || other.class == Spock
  end

  def <(other)
    other.class == Scissors || other.class == Lizard
  end
end

class Scissors < Move
  def >(other)
    other.class == Paper || other.class == Lizard
  end

  def <(other)
    other.class == Rock || other.class == Spock
  end
end

class Lizard < Move
  def >(other)
    other.class == Paper || other.class == Spock
  end

  def <(other)
    other.class == Rock || other.class == Scissors
  end
end

class Spock < Move
  def >(other)
    other.class == Rock || other.class == Scissors
  end

  def <(other)
    other.class == Paper || other.class == Lizard
  end
end

class Sloth < Move
  def >(*)
    false
  end

  def <(*)
    true
  end
end

class Player
  attr_accessor :name, :move, :turbo_move

  def initialize
    set_name
  end
end

class Human < Player
  attr_accessor :champion

  LONGEST_NAME_LENGTH = 17

  def initialize
    super
    @champion = false
  end

  def valid_name
    loop do
      n = gets.chomp
      if n.empty?
        puts "Sorry, please enter a name."
      elsif n.length > LONGEST_NAME_LENGTH
        puts "Sorry, please enter a shorter name."
      else
        return n
      end
    end
  end

  def set_name
    puts "To begin, type your name:"
    self.name = valid_name
  end

  def valid_choice
    choice = gets.chomp.downcase
    loop do
      break if %w(rock r paper p scissors sc lizard l spock sp).include?(choice)
      puts "Sorry, invalid choice."
      choice = gets.chomp.downcase
    end
    choice
  end

  def choose
    puts "Choose (r)ock, (p)aper, (sc)issors, (l)izard, or (sp)ock:"
    self.move = make_move(valid_choice)
  end

  def choose_2
    self.turbo_move = make_move(valid_choice)
  end

  def choose_dash
    Timeout.timeout(Dash::SECONDS) { choose }
  rescue Timeout::Error
    choice = "timeout"
    self.move = make_move(choice)
  end

  def choose_turbo
    self.move = Sloth.new
    begin
      Timeout.timeout(Turbo::SECONDS) do
        choose
        choose_2
      end
    rescue Timeout::Error
      choice = "timeout"
      self.turbo_move = make_move(choice)
    end
  end

  def make_move(choice)
    case choice
    when 'rock', 'r' then Rock.new
    when 'paper', 'p' then Paper.new
    when 'scissors', 'sc' then Scissors.new
    when 'lizard', 'l' then Lizard.new
    when 'spock', 'sp' then Spock.new
    else
      Sloth.new
    end
  end
end

class Computer < Player
  POSSIBLE_MOVES = [Rock.new, Paper.new, Scissors.new, Lizard.new, Spock.new]

  def set_name
    self.name = self.class.to_s
  end

  def choose
    self.move = POSSIBLE_MOVES.sample
  end
end

class Reggie < Computer
  def to_s
    "#{name} plays old fashioned RPSLS."
  end
end

class Cici < Computer
  def choose(round)
    probability = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].sample
    self.move = if probability >= 8 || round.history.empty?
                  Computer::POSSIBLE_MOVES.sample
                else
                  round.history.values.last[0]
                end
  end

  def to_s
    "#{name} has a tendency to copy your last move."
  end
end

class Sonia < Computer
  def choose(round)
    probability = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].sample
    if probability >= 8 || round.history.empty?
      self.move = Computer::POSSIBLE_MOVES.sample
    else
      new_move = Sloth.new
      until new_move > win_or_tie_move(round)
        new_move = Computer::POSSIBLE_MOVES.sample
      end
      self.move = new_move
    end
  end

  def win_or_tie_move(round)
    if round.history.values.last[2] == "Lost"
      round.history.values.last[1]
    else
      round.history.values.last[0]
    end
  end

  def to_s
    "#{name} likes to beat the previous winning or tying hand."
  end
end

class Dash < Computer
  SECONDS = 3

  def to_s
    "#{name} reveals his hand and forces you to play quickly."
  end
end

class Turbo < Computer
  SECONDS = 5

  def choose
    super
    self.turbo_move = Computer::POSSIBLE_MOVES.sample
  end

  def to_s
    "#{name} reveals two hands and forces you to win both quickly."
  end
end

class Round
  attr_accessor :number, :wins, :losses, :ties, :result, :champion
  attr_accessor :history, :turbo_history

  WINNING_SCORE = 5

  def initialize
    @number = 0
    @wins = 0
    @losses = 0
    @ties = 0
    @result = nil
    @history = {}
    @turbo_history = {}
    @champion = nil
  end
end

class Game
  include Displayable

  attr_accessor :human, :computer, :round, :game_mode

  def play
    welcome_screen
    @human = Human.new
    choose_game_mode
    goodbye_screen
  end

  def welcome_screen
    system 'clear'
    display_welcome_message
    display_instructions
  end

  def display_welcome_message
    center "WELCOME"
    center "to"
    center "ROCK, PAPER, SCISSORS, LIZARD, SPOCK"
    center "---"
  end

  def display_instructions
    center "GAME RULES"
    center "Scissors cuts Paper covers Rock crushes"
    center "Lizard poisons Spock smashes Scissors"
    center "decapitates Lizard eats Paper disproves"
    center_break "Spock vaporizes Rock crushes Scissors"
  end

  def choose_game_mode
    loop do
      display_game_mode
      mode = find_mode
      practice if ['p', 'practice'].include?(mode)
      tournament if ['t', 'tournament'].include?(mode)
      break if ['q', 'quit'].include?(mode)
    end
  end

  def display_game_mode
    system 'clear'
    center "Hi, #{human.name}!"
    center "---"
    center_break "GAME MODES"
    center "(P)ractice"
    center_break "Test your skills against one of five opponents."
    center "(T)ournament"
    center_break "Defeat all five opponents to become Champion!"
  end

  def find_mode
    puts "Choose a game mode or (q)uit:"
    mode = gets.chomp.downcase
    loop do
      break if ['p', 'practice', 't', 'tournament', 'q', 'quit'].include?(mode)
      puts "Please choose (P)ractice, (T)ournament, or (Q)uit:"
      mode = gets.chomp.downcase
    end
    mode
  end

  def practice
    self.game_mode = "p"
    loop do
      @round = Round.new
      practice_welcome
      @computer = set_opponent
      opponent_message
      break if play_opponent == "quit"
    end
  end

  def practice_welcome
    system 'clear'
    center "WELCOME to PRACTICE"
    center "---"
    center_break "Choose any of the five opponents to begin:"
    display_opponents
  end

  def display_opponents
    center Reggie.new.to_s
    center Cici.new.to_s
    center Sonia.new.to_s
    center Dash.new.to_s
    center_break Turbo.new.to_s
  end

  def set_opponent
    case choose_opponent
    when 'reggie', 'r' then Reggie.new
    when 'cici', 'c' then Cici.new
    when 'sonia', 's' then Sonia.new
    when 'Dash', 'd' then Dash.new
    when 'turbo', 't' then Turbo.new
    end
  end

  def choose_opponent
    puts "Choose opponent: (R)eggie, (C)ici, (S)onia, (D)ash, or (T)urbo"
    opp = gets.chomp.downcase
    loop do
      break if %w(reggie r cici c sonia s Dash d turbo t).include?(opp)
      puts "Sorry, please choose a valid opponent."
      opp = gets.chomp.downcase
    end
    opp
  end

  def opponent_message
    system 'clear'
    center_break "Your opponent is"
    center computer.name.upcase
    center "---"
    center_break computer.to_s
    continue_with_enter
  end

  def continue_with_enter
    puts "Press enter to continue."
    answer = gets
    loop do
      break if %W(continue\n \n).include?(answer)
      puts "Please press enter to continue."
      answer = gets
    end
  end

  def play_opponent
    loop do
      opponent_type
      return if round_winner?
      decision = continue_prompt
      return decision unless decision == "continue"
    end
  end

  def opponent_type
    case computer.name
    when "Reggie" then play_reggie
    when "Cici" then play_cici
    when "Sonia" then play_sonia
    when "Dash" then play_dash
    when "Turbo" then play_turbo
    end
  end

  def continue_prompt
    if game_mode == "p"
      practice_prompt
    else
      tournament_prompt
    end
  end

  def practice_prompt
    puts "Continue (enter) / (S)witch Opponent / (Q)uit Practice"
    answer = gets.downcase
    loop do
      break if %W(continue\n \n switch\n s\n quit\n q\n).include?(answer)
      puts "Sorry, invalid response."
      answer = gets.downcase
    end
    return "continue" if ["continue\n", "\n"].include?(answer)
    return "quit" if ["quit", "q"].include?(answer.chomp)
  end

  def tournament_prompt
    puts "Continue (enter) / (Q)uit Tournament"
    answer = gets.downcase
    loop do
      break if %W(continue\n \n quit\n q\n).include?(answer)
      puts "Sorry, invalid response."
      answer = gets.downcase
    end
    return "continue" if ["continue\n", "\n"].include?(answer)
    return "quit" if ["quit", "q"].include?(answer.chomp)
  end

  def tournament
    self.game_mode = "t"
    tournament_welcome
    return unless continue_prompt == "continue"
    tournament_opponent
    champion_message if human.champion
  end

  def tournament_welcome
    system 'clear'
    center "WELCOME to the TOURNAMENT"
    center "---"
    center_break "You will face all 5 opponents in succession."
    display_opponents
    center_break "Win #{Round::WINNING_SCORE} hands to defeat the opponent."
    center_break "Defeat all 5 opponents to become RPSLS Champion!"
  end

  def tournament_opponent
    [Reggie.new, Cici.new, Sonia.new, Dash.new, Turbo.new].each do |opponent|
      play_tournament(opponent)
      if round.wins == Round::WINNING_SCORE
        next_opponent
        next
      else
        failed_tournament_message
        break
      end
    end
  end

  def play_tournament(opponent)
    @computer = opponent
    @round = Round.new
    opponent_message
    play_opponent
  end

  def next_opponent
    system 'clear'
    if computer.class == Turbo
      human.champion = true
      display_history_turbo
    else
      display_history
    end
    display_score
    puts
    next_opponent_message
  end

  def next_opponent_message
    center_break "Nice job! You defeated #{computer.name}!"
    return continue_with_enter if computer.class == Turbo
    center_break "Moving to the next opponent."
    continue_with_enter
  end

  def failed_tournament_message
    system 'clear'
    computer.class == Turbo ? display_history_turbo : display_history
    display_score
    puts
    center_break "You were defeated by #{computer.name}."
    center_break "Better luck next time."
    continue_with_enter
  end

  def champion_message
    system 'clear'
    center ">-----<"
    center_break "CONGRATULATIONS, #{human.name}!"
    center "You are the"
    center "RPSLS Champion!"
    center_break ">-----<"
    human.champion = false
    continue_with_enter
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
    outer_col_width = "Result".length + 2
    inner_col_width = Human::LONGEST_NAME_LENGTH + 2
    center "MOVE HISTORY"
    format_history_1(outer_col_width, inner_col_width)
    format_history_2(outer_col_width, inner_col_width)
    puts
  end

  def format_history_1(outer_col_width, inner_col_width)
    center "Round".center(outer_col_width) +
           human.name.to_s.center(inner_col_width) +
           computer.name.to_s.center(inner_col_width) +
           "Result".center(outer_col_width)
    center "-" * ((outer_col_width + inner_col_width) * 2)
  end

  def format_history_2(outer_col_width, inner_col_width)
    round.history.each do |round_num, move_history|
      center round_num.to_s.center(outer_col_width) +
             move_history[0].to_s.center(inner_col_width) +
             move_history[1].to_s.center(inner_col_width) +
             move_history[2].to_s.center(outer_col_width)
    end
  end

  def display_history_turbo
    outer_col_width = "Result".length + 2
    inner_col_width = Human::LONGEST_NAME_LENGTH + 2
    center "MOVE HISTORY"
    format_history_turbo_1(outer_col_width, inner_col_width)
    format_history_turbo_2(outer_col_width, inner_col_width)
    puts
  end

  def format_history_turbo_1(outer_col_width, inner_col_width)
    center "Round".center(outer_col_width) +
           human.name.to_s.center(inner_col_width) +
           computer.name.to_s.center(inner_col_width) +
           "Result".center(outer_col_width)
    center "-" * ((outer_col_width + inner_col_width) * 2)
  end

  def format_history_turbo_2(outer_col_width, inner_col_width)
    round.turbo_history.each do |round_num, move_history|
      center round_num.to_s.center(outer_col_width) +
             "#{move_history[0]}/#{move_history[1]}".center(inner_col_width) +
             "#{move_history[2]}/#{move_history[3]}".center(inner_col_width) +
             move_history[4].to_s.center(outer_col_width)
    end
  end

  def display_score
    column_width = (16 + (Human::LONGEST_NAME_LENGTH + 2) * 2) / 3
    center "SCORE"
    center "-" * (column_width * 3)
    format_score(column_width)
  end

  def format_score(column_width)
    center "#{human.name}: #{round.wins}".center(column_width) +
           "#{computer.name}: #{round.losses}".center(column_width) +
           "Ties: #{round.ties}".center(column_width)
    puts
  end

  def display_moves
    center "#{computer.name} chose #{computer.move}."
    center_break "#{human.name} chose #{human.move}."
  end

  def display_move_dash
    center_break "#{computer.name} chose #{computer.move}."
  end

  def display_move_turbo
    center_break "#{computer.name} chose #{computer.move} and " \
    "#{computer.turbo_move}."
  end

  def display_human_move_turbo
    center "#{computer.name} chose #{computer.move} and #{computer.turbo_move}."
    center_break "#{human.name} chose #{human.move} and #{human.turbo_move}."
  end

  def determine_result
    round.result = if human.move > computer.move
                     "Won"
                   elsif human.move < computer.move
                     "Lost"
                   else
                     "Tied"
                   end
  end

  def determine_result_turbo
    hm = human.move
    cm = computer.move
    htm = human.turbo_move
    ctm = computer.turbo_move
    round.result = if hm > cm && htm > ctm then "Won"
                   elsif hm < cm || htm < ctm then "Lost"
                   else "Tied"
                   end
  end

  def tally_score
    round.number += 1
    if round.result == "Won"
      round.wins += 1
    elsif round.result == "Lost"
      round.losses += 1
    else
      round.ties += 1
    end
  end

  def record_moves
    round.history[round.number] = [human.move, computer.move, round.result]
  end

  def record_moves_turbo
    round.turbo_history[round.number] = [
      human.move,
      human.turbo_move,
      computer.move,
      computer.turbo_move,
      round.result
    ]
  end

  def display_winner
    if round.result == "Won"
      center "#{human.name} won!"
    elsif round.result == "Lost"
      center "#{computer.name} won."
    else
      center "It's a tie."
    end
    puts
  end

  def round_winner?
    score = Round::WINNING_SCORE
    return true if game_mode == "t" && [round.wins, round.losses].max == score
    false
  end

  def play_reggie
    set_round_screen
    computer.choose
    human.choose
    round_execution
  end

  def play_cici
    set_round_screen
    computer.choose(round)
    human.choose
    round_execution
  end

  def play_sonia
    set_round_screen
    computer.choose(round)
    human.choose
    round_execution
  end

  def play_dash
    set_round_screen
    computer.choose
    display_move_dash
    human.choose_dash
    round_execution
  end

  def play_turbo
    set_round_screen_turbo
    computer.choose
    display_move_turbo
    human.choose_turbo
    round_execution_turbo
  end

  def round_execution
    set_round_screen
    determine_result
    tally_score
    record_moves
    set_round_screen
    display_moves
    display_winner
  end

  def round_execution_turbo
    set_round_screen_turbo
    determine_result_turbo
    tally_score
    record_moves_turbo
    set_round_screen_turbo
    display_human_move_turbo
    display_winner
  end

  def goodbye_screen
    system 'clear'
    center "THANK YOU"
    center "for playing"
    center "ROCK, PAPER, SCISSORS, LIZARD, SPOCK"
    center "---"
    center "good bye"
  end
end

Game.new.play
