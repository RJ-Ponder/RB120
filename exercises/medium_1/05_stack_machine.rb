require 'pry'
class MinilangError < StandardError; end
class EmptyStackError < MinilangError; end
class InvalidTokenError < MinilangError; end

class Minilang
  attr_accessor :register, :stack

  VALID_TOKENS = %w(push add sub mult div mod pop print)

  def initialize(program)
    @raw_program = program
    @register = 0
    @stack = []
    @invalid_tokens = []
  end

  def eval(optional_parameter = {})
    @program = format(@raw_program, optional_parameter)
    validate_program
    run_program
  rescue MinilangError => e # added MinilangError as intermediate
    puts e.message
  end

  private

  def validate_program
    @invalid_tokens = @program.split.reject do |token|
      token.match?(/\A[-+]?[0-9]+\z/) || VALID_TOKENS.include?(token.downcase)
    end
    return if @invalid_tokens.empty?
    raise InvalidTokenError, "Invalid token(s): #{@invalid_tokens.join(', ')}"
  end

  def run_program # originally had large case statement; used send to simplify.
    @program.split.each do |token|
      if token.to_i.to_s == token
        self.register = token.to_i
      else
        send(token.downcase)
      end
    end
  end

  def invalid_token_error_message
    puts "Invalid token(s): #{@invalid_tokens.join(', ')}"
  end

  def push
    stack.push(register)
  end

  def add
    self.register += pop_stack
  end

  def sub
    self.register -= pop_stack
  end

  def mult
    self.register *= pop_stack
  end

  def div
    self.register /= pop_stack
  end

  def mod
    self.register %= pop_stack
  end

  def pop
    self.register = pop_stack
  end

  def pop_stack # so no ambiguity in order of operations (FE # 2)
    raise EmptyStackError, "Empty stack!" if stack.empty?
    stack.pop
  end

  def print
    puts register
  end
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)

# CENTIGRADE_TO_FAHRENHEIT =
#   '5 PUSH %<degrees_c>d PUSH 9 MULT DIV PUSH 32 ADD PRINT'
# Minilang.new(format(CENTIGRADE_TO_FAHRENHEIT, degrees_c: 100)).eval
# # 212
# Minilang.new(format(CENTIGRADE_TO_FAHRENHEIT, degrees_c: 0)).eval
# # 32
# Minilang.new(format(CENTIGRADE_TO_FAHRENHEIT, degrees_c: -40)).eval
# # -40

CENTIGRADE_TO_FAHRENHEIT =
  '5 PUSH %<degrees_c>d PUSH 9 MULT DIV PUSH 32 ADD PRINT'
minilang = Minilang.new(CENTIGRADE_TO_FAHRENHEIT)
minilang.eval(degrees_c: 100)
# 212
minilang.eval(degrees_c: 0)
# 32
minilang.eval(degrees_c: -40)
# -40

FAHRENHEIT_TO_CENTIGRADE = 
  '9 PUSH 32 PUSH %<degrees_f>d SUB PUSH 5 MULT DIV PRINT'
minilang = Minilang.new(FAHRENHEIT_TO_CENTIGRADE)
minilang.eval(degrees_f: 212)
minilang.eval(degrees_f: 32)
minilang.eval(degrees_f: -40)
minilang.eval(degrees_f: 70)

MPH_TO_KPH = 
  '1000 PUSH %<miles_per_hour>d PUSH 1609 MULT DIV PRINT'
minilang = Minilang.new(MPH_TO_KPH)
minilang.eval(miles_per_hour: 70)
minilang.eval(miles_per_hour: 30)

AREA_OF_RECTANGLE = 
  '%<length>d PUSH %<width>d MULT PRINT'
minilang = Minilang.new(AREA_OF_RECTANGLE)
minilang.eval(length: 50, width: 10)
