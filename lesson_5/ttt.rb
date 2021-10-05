require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      return @squares[line[0]].marker if line_wins?(@squares.values_at(*line))
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def draw
    puts "     |     |     "
    puts " #{@squares[7]} | #{@squares[8]} | #{@squares[9]} "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts " #{@squares[4]} | #{@squares[5]} | #{@squares[6]} "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts " #{@squares[1]} | #{@squares[2]} | #{@squares[3]} "
    puts "     |     |     "
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  private

  def line_wins?(squares)
    return false if squares.any?(&:unmarked?)
    squares.collect(&:marker).uniq.size == 1
  end
end

class Square
  INITIAL_MARKER = "   "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Player
  attr_accessor :name, :marker

  def initialize(marker)
    @marker = marker
  end
end

class TTTGame
  HUMAN_MARKER = " X "
  COMPUTER_MARKER = " O "
  DIFFICULTY_VALUE = { e: 50, m: 75, h: 90, i: 100 }
  DIFFICULTY_LEVEL = {
    "e" => "Easy",
    "m" => "Medium",
    "h" => "Hard",
    "i" => "Impossible"
  }
  COMPUTER_NAMES = {
    "e" => "Edna",
    "m" => "Merve",
    "h" => "Harry",
    "i" => "Ivy"
  }
  FIRST_TO_MOVE = "human"
  MAX_SCORE = 2

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_turn = FIRST_TO_MOVE
    @difficulty = 50
    @human_score = 0
    @computer_score = 0
    @tie_score = 0
  end

  def play
    display_welcome_message
    welcome_player
    loop do
      main_game
      display_game_result if max_score_reached?
      break unless play_again?
      reset_game
    end
    display_goodbye_message
  end

  private

  def display_welcome_message
    clear
    puts "Welcome to Tic Tac Toe!"
    puts
  end

  def clear
    system "clear"
  end

  def welcome_player
    prompt_for_name
    clear
    puts "Welcome, #{human.name}!"
    human.marker = choose_human_marker
    computer.marker = determine_computer_marker
    @difficulty = choose_computer_difficulty
    puts
  end

  def prompt_for_name
    puts "To begin, type your name:"
    human.name = valid_name
  end

  def valid_name
    loop do
      n = gets.chomp.strip
      return n unless n.empty?
      puts "Sorry, please enter a name."
    end
  end

  def choose_human_marker
    puts "Enter anything 1 - 3 characters long to use as your marker:"
    marker = nil
    loop do
      marker = gets.chomp.strip
      break if marker.length <= 3
      puts "Sorry, must be 1-3 characters long."
    end
    return marker.center(3) unless marker.empty?
    puts "Defaulted to X."
    " X "
  end

  def determine_computer_marker
    if human.marker.downcase.start_with?("o")
      " X "
    else
      " O "
    end
  end

  def choose_computer_difficulty
    puts "What level of difficulty do you want?"
    puts "(E)asy, (M)edium, (H)ard, (I)mpossible"
    difficulty = nil
    loop do
      difficulty = gets.chomp.strip.downcase
      break if %(e easy m medium h hard i impossible).include?(difficulty)
      puts "Please choose a valid difficulty."
    end
    display_difficulty(difficulty)
    DIFFICULTY_VALUE[difficulty.downcase[0].to_sym]
  end

  def display_difficulty(difficulty)
    computer.name = COMPUTER_NAMES[difficulty.downcase[0]]
    puts "Difficulty set to #{DIFFICULTY_LEVEL[difficulty.downcase[0]]}."
    puts "You are playing #{computer.name}."
  end

  def main_game
    loop do
      display_board
      player_move
      keep_score
      display_result
      break if max_score_reached?
      break unless play_another_round?
      reset
      display_play_again_message
    end
  end

  def display_board
    puts "#{human.name} is #{human.marker.strip}. " \
         "#{computer.name} is #{computer.marker.strip}."
    puts "First to #{MAX_SCORE} wins."
    puts
    display_score
    puts ""
    board.draw
    puts ""
  end

  def display_score
    puts "Score - #{human.name}: #{@human_score}, #{computer.name}: " \
         " #{@computer_score}, Ties: #{@tie_score}"
  end

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board
    end
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_turn = "computer"
    else
      computer_moves
      @current_turn = "human"
    end
  end

  def human_turn?
    @current_turn == FIRST_TO_MOVE
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def joinor(unmarked_spaces, punctuation = ', ', conjunction = 'or')
    array = unmarked_spaces
    new_array = array[0..-2]
    last = array.last
    case array.size
    when 0 then ""
    when 1 then array.first.to_s
    when 2 then "#{array.first} #{conjunction} #{array.last}"
    else (new_array + ["#{conjunction} #{last}"]).join(punctuation)
    end
  end

  def computer_moves
    random = (1..100).to_a.sample
    if random > @difficulty
      board[board.unmarked_keys.sample] = computer.marker
    else
      make_best_move
    end
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def make_best_move
    best_value = -100
    possible_moves = {}
    board.unmarked_keys.each do |empty_space|
      board[empty_space] = computer.marker
      move_value = minimax(0, false)
      board[empty_space] = Square::INITIAL_MARKER
      possible_moves[empty_space] = move_value
      best_value = move_value if move_value > best_value
    end
    best_move = possible_moves.select { |_, v| v == best_value }.keys.sample
    board[best_move] = computer.marker
  end

  def minimax(depth, maximizer_move)
    score = evaluate(depth)

    return score unless score == 0 && board.full? == false

    if maximizer_move
      best = -100
      board.unmarked_keys.each do |empty_space|
        board[empty_space] = computer.marker
        best = [best, minimax(depth + 1, !maximizer_move)].max
        board[empty_space] = Square::INITIAL_MARKER
      end
    else
      best = 100
      board.unmarked_keys.each do |empty_space|
        board[empty_space] = human.marker
        best = [best, minimax(depth + 1, !maximizer_move)].min
        board[empty_space] = Square::INITIAL_MARKER
      end
    end
    best
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def evaluate(depth)
    if board.winning_marker == computer.marker
      10 - depth
    elsif board.winning_marker == human.marker
      -10 + depth
    else
      0
    end
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def keep_score
    case board.winning_marker
    when human.marker
      @human_score += 1
    when computer.marker
      @computer_score += 1
    else
      @tie_score += 1
    end
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "#{human.name} won!"
    when computer.marker
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def max_score_reached?
    @human_score == MAX_SCORE || @computer_score == MAX_SCORE
  end

  def play_another_round?
    answer = nil
    loop do
      puts "Would you like to play another round? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def reset
    board.reset
    @current_turn = FIRST_TO_MOVE
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts
  end

  def display_game_result
    puts
    if @human_score == MAX_SCORE
      puts "Congratulations! #{human.name} won the game!"
    else
      puts "Sorry, the #{computer.name} won the game."
    end
    puts
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play another game to #{MAX_SCORE}? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def reset_game
    reset
    @human_score = 0
    @computer_score = 0
    @tie_score = 0
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end
end

game = TTTGame.new
game.play
