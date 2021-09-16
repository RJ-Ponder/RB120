# require 'timeout'
# require 'io/console'

# # computer1 = %w(rock paper scissors lizard spock).sample
# # computer2 = %w(rock paper scissors lizard spock).sample
# # puts computer1
# # puts computer2

# # answer1 = nil
# # answer2 = nil

# # begin
# #   Timeout::timeout(3) do
# #     answer1 = gets.chomp
# #     answer2 = gets.chomp
# #   end
# # rescue Timeout::Error
# #   answer1 = nil
# #   answer2 = nil
# # end

# # if answer1 == computer1 && answer2 == computer2
# #   puts "you win"
# # else
# #   puts "you lose"
# # end

# # col, row = IO.console.winsize
# # puts "hello"
# # system 'clear'

# # def prompt(message, col)
# #   puts " " * (col / 2) + "#{message}" + " " * (col / 2)
# # end

# # prompt("This is a test", col)

# # choice = nil
    
# # begin
# #   Timeout::timeout(5) do
# #     loop do
# #       puts "Quick! r, p, s, l, or sp:"
# #       choice = gets.chomp.downcase
# #       break if %w(rock r paper p scissors s lizard l spock sp).include?(choice)
# #       puts "Sorry, invalid choice."
# #     end
# #   end
# # rescue Timeout::Error
# #   choice = "timeout"
# # end

# # puts choice

# choice_1 = nil
# choice_2 = nil
# options = %w(rock r paper p scissors s lizard l spock sp)

# begin
#   Timeout.timeout(5) do
#     loop do
#       puts "Quick! r, p, s, l, or sp:"
#       choice_1 = gets.chomp.downcase
#       choice_2 = gets.chomp.downcase
#       break if options.include?(choice_1) && options.include?(choice_2)
#       puts "Sorry, at least one invalid choice."
#     end
#   end
# rescue Timeout::Error
#   choice_1 = "timeout 1"
#   choice_2 = "timeout 2"
# end

# puts choice_1
# puts choice_2

# system 'clear'
# puts "------------------------------------------------"
#     puts "WELCOME".center(48)
#     puts "to".center(48)
#     puts "ROCK, PAPER, SCISSORS, LIZARD, SPOCK".center(48)
#     puts "------------------------------------------------"

#     puts "------------------------------------------------"
#     puts "THANK YOU".center(48)
#     puts "for playing".center(48)
#     # puts "playing".center(48)
#     puts "ROCK, PAPER, SCISSORS, LIZARD, SPOCK".center(48)
#     puts "------------------------------------------------"

# def play
#   puts "play method"
#   choose_game
#   puts "running"
# end

# def choose_game
#   puts "choose p or t:"
#   answer = gets.chomp
#   if answer == "p"
#     practice and return
#   else
#     tournament and return
#   end
# end

# def practice
#   puts "practice method"
  
# end

# def tournament
#   puts "tournament method"
# end

# def play_opponent
#     loop do
#       case computer.name
#       when "Reggie" then play_reggie
#       when "Cici" then play_cici
#       when "Sonia" then play_sonia
#       when "Dash" then play_dash
#       when "Turbo" then play_turbo
#       end
#       decision = continue_prompt
#       return decision unless decision == "continue"
#     end
# end

# p true.class
# p "hello".class
# p [1, 2, 3, "happy days"].class
# p 142.class
# SCREEN_WIDTH = 62

# def center(message)
#   puts message.center(SCREEN_WIDTH)
# end

# def center_break(message)
#   puts message.center(SCREEN_WIDTH)
#   puts
# end

# def champion_message
#   system 'clear'
#   center ">-----<"
#   center_break "CONGRATULATIONS, RJ!"
#   center "You are the" 
#   center "RPSLS Champion!"
#   center_break ">-----<"
#   puts "Press enter to continue."
# end

# champion_message

class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def self.hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

Hello.hi