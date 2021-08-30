# COME BACK TO REFACTOR

require 'pry'
class Banner
  WINDOW = 76
  def initialize(message, width = 0)
    @message = message
    if width > 0 && width <= WINDOW
      @width = width
    elsif message.length == 0
      @width = 1
    else
      @width = [WINDOW, message.length].min
    end
    @length = message.length
    @empty = ' ' * @width
    @horizontal = '-' * @width
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    "+-#{@horizontal}-+"
  end

  def empty_line
    "| #{@empty} |"
  end

  def message_line
    if @width % WINDOW == 0
      line_number1 = @width / WINDOW
    else
      line_number1 = (@width / WINDOW) + 1
    end
      
    if @length % @width == 0
      line_number2 = @length / @width
    else
      line_number2 = (@length / @width) + 1
    end
    
    line_number = [line_number1, line_number2].max

    line_lengths = []
    message_length = @length

    loop do
      break if line_number == 0
      last_line = message_length / line_number
      line_lengths.unshift(last_line)
      message_length -= last_line
      line_number -= 1
    end
    
    index = 0
    wrap = []
    # binding.pry
    line_lengths.each do |length|
      wrap << "| #{@message[index, length].center(@width)} |"
      index += length
    end
    
    wrap.join("\n")
  end
end
string = "The contents of this email and any attachments are confidential to the intended recipient. They may not be disclosed to or used by or copied in any way by anyone other than the intended recipient. If this email is received in error, please contact the sender of this e-mail and then delete it. For more information on how we process personal data, please see https://www.fareva.com/en-gb/PrivacyPolicy. Please note that neither FAREVA RICHMOND  nor the sender accepts any responsibility for viruses and it is your responsibility to scan or otherwise check this email and any attachments. This communication is issued on behalf of FAREVA RICHMOND, and individuals or legal entities (other than FAREVA RICHMOND) that are involved in the services provided by, or on behalf of, FAREVA RICHMOND cannot be held liable in any way whatsoever."
banner1 = Banner.new(string, 30)
puts banner1
# +--------------------------------------------+
# |                                            |
# | To boldly go where no one has gone before. |
# |                                            |
# +--------------------------------------------+

banner2 = Banner.new('', 50)
puts banner2
# +--+
# |  |
# |  |
# |  |
# +--+


# line_lengths = []
# line_lengths = []
# line_number = 4
# message_length = 202

# loop do
#   break if line_number == 0
#   last_line = message_length / line_number
#   line_lengths.unshift(last_line)
#   message_length -= last_line
#   line_number -= 1
# end

# message = "a" * 202
# index = 0
# wrap = []

# line_lengths.each do |length|
#   wrap << message[index, length]
#   index += length
# end

# puts wrap.join("\n")