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

col, row = IO.console.winsize
puts "hello"
system 'clear'

def prompt(message, col)
  puts " " * (col / 2) + "#{message}" + " " * (col / 2)
end

prompt("This is a test", col)