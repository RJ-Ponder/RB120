=begin
Description
- A random number between 1 - 100 is chosen. The player has 7 valid guesses to try and guess the number. If the player guesses it right he wins, otherwise he loses.
Nouns and Verbs
- Nouns: player, number, guess
- Verbs: choose, guess
Organization
- Game generates a random number that will be the winning number
- Player guesses
=end

class Player
  MAX_GUESSES = 7
  attr_accessor :guess
  
  def initialize
    @guesses = 0
    @guess = 0
  end
  
  def make_guess
    puts "Enter a number between #{GuessingGame::LOWER} and #{GuessingGame::UPPER}:"
    validate_guess
    @guesses += 1
  end
  
  def validate_guess
    loop do
      self.guess = gets.chomp.to_i
      break if (GuessingGame::LOWER..GuessingGame::UPPER).to_a.include?(guess)
      puts "Invalid guess. Enter a number between 1 and 100:"
    end
  end
  
  def guesses_left
    MAX_GUESSES - @guesses
  end
  
  def guesses_left_msg
    puts "You have #{guesses_left} guesses remaining."
  end
end

class GuessingGame
  attr_accessor :player
  
  LOWER = 1
  UPPER = 100
  
  def initialize
    @winning_number = nil
    @player = Player.new
  end
  
  def generate_number
    @winning_number = (LOWER..UPPER).to_a.sample
  end
  
  def check_guess
    if player.guess == @winning_number
      puts "That's the number!"
    elsif player.guess < @winning_number
      puts "Your guess is too low."
      puts
    else
      puts "Your guess is too high."
      puts
    end
  end
  
  def won?
    player.guess == @winning_number
  end
  
  def play
    system 'clear'
    generate_number
    loop do
      player.guesses_left_msg
      player.make_guess
      check_guess
      break if won? || player.guesses_left == 0
    end
    if won?
      puts "You won!"
    else
      puts "You have no more guesses."
      puts "You lost!"
    end
  end
end

game = GuessingGame.new
game.play

