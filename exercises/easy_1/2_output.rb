class Pet
  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def to_s
    # @name.upcase! # notes below correspond to this
    "My name is #{@name.upcase}."
  end
end

# name = 'Fluffy'
# fluffy = Pet.new(name)
# puts fluffy.name # calls to_s for the string class, because fluffy.name is a string
# puts fluffy # calls custom to_s method which destructively modifies the string and displays it
# puts fluffy.name # calls to_s for the string class, but the string was destructively modified
# puts name # getter method that still references the destructively modified string

name = 42
fluffy = Pet.new(name) # to_s on the integer returns a new string object anyway
name += 1 # name is reassigned
puts fluffy.name # "42"
puts fluffy # "My name is 42"
puts fluffy.name # remains "42"
puts name # points to a new object, 43