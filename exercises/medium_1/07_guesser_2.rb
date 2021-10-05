class GuessingGame
  def initialize(lower = 1, upper = 100)
    @lower = lower
    @upper = upper
    @max_guesses = Math.log2(upper - lower).to_i + 1
    @winning_number = nil
    @guess = 0
    @guesses = 0
  end

  def play
    system 'clear'
    generate_number
    loop do
      guesses_left_msg
      make_guess
      check_guess
      break if won? || guesses_left == 0
    end
    display_result
  end

  private

  attr_reader :lower, :upper
  attr_accessor :guess

  def generate_number
    @winning_number = (lower..upper).to_a.sample
  end

  def guesses_left_msg
    puts "You have #{guesses_left} guesses remaining."
  end

  def guesses_left
    @max_guesses - @guesses
  end

  def make_guess
    puts "Enter a number between #{lower} and #{upper}:"
    validate_guess
    @guesses += 1
  end

  def validate_guess
    loop do
      self.guess = gets.chomp.to_i
      break if (lower..upper).to_a.include?(guess)
      puts "Invalid guess. Enter a number between 1 and 100:"
    end
  end

  def check_guess
    if guess == @winning_number
      puts "That's the number!"
    elsif guess < @winning_number
      puts "Your guess is too low."
      puts
    else
      puts "Your guess is too high."
      puts
    end
  end

  def won?
    guess == @winning_number
  end

  def display_result
    if won?
      puts "You won!"
    else
      puts "You have no more guesses."
      puts "You lost!"
      puts "The number was #{@winning_number}."
    end
  end
end

game = GuessingGame.new(1, 500)
game.play
