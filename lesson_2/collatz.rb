# # recursive
# def collatz(number, list)
#   return list if list.last == 1
  
#   if number % 2 > 0
#     number = number * 3 + 1
#   else
#     number = number / 2
#   end
#   list << number

#   collatz(list.last, list)
# end

# p collatz(486546835456456456445, [])

# loop
def collatz(number)
  list = []
  even = 0
  odd = 0
  loop do
    break if [1, -1, -5, -17, 0].include?(number)
    
    if number % 2 > 0
      number = number * 3 + 1
      list << 1
    else
      number = number / 2
      list << 0
    end
    # list << number
  end

  list
end

p collatz(481011)
p collatz(488860)
p collatz(592302)
p collatz(175520)
p collatz(998124)
p collatz(332542)
p collatz(762998)
p collatz(867830)
p collatz(717562)
p collatz(344755)
