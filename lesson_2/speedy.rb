require 'timeout'
require 'io/console'

# computer1 = %w(rock paper scissors lizard spock).sample
# computer2 = %w(rock paper scissors lizard spock).sample
# puts computer1
# puts computer2

# answer1 = nil
# answer2 = nil

# begin
#   Timeout::timeout(3) do
#     answer1 = gets.chomp
#     answer2 = gets.chomp
#   end
# rescue Timeout::Error
#   answer1 = nil
#   answer2 = nil
# end

# if answer1 == computer1 && answer2 == computer2
#   puts "you win"
# else
#   puts "you lose"
# end

# col, row = IO.console.winsize
# puts "hello"
# system 'clear'

# def prompt(message, col)
#   puts " " * (col / 2) + "#{message}" + " " * (col / 2)
# end

# prompt("This is a test", col)

# choice = nil
    
# begin
#   Timeout::timeout(5) do
#     loop do
#       puts "Quick! r, p, s, l, or sp:"
#       choice = gets.chomp.downcase
#       break if %w(rock r paper p scissors s lizard l spock sp).include?(choice)
#       puts "Sorry, invalid choice."
#     end
#   end
# rescue Timeout::Error
#   choice = "timeout"
# end

# puts choice

choice_1 = nil
choice_2 = nil
options = %w(rock r paper p scissors s lizard l spock sp)

begin
  Timeout::timeout(5) do
    loop do
      puts "Quick! r, p, s, l, or sp:"
      choice_1 = gets.chomp.downcase
      choice_2 = gets.chomp.downcase
      break if options.include?(choice_1) && options.include?(choice_2)
      puts "Sorry, at least one invalid choice."
    end
  end
rescue Timeout::Error
  choice_1 = "timeout 1"
  choice_2 = "timeout 2"
end

puts choice_1
puts choice_2