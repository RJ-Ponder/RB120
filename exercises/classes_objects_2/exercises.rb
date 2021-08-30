# class Cat
#   def self.generic_greeting
#     puts "Hello! I'm a cat!"
#   end
# end

# Cat.generic_greeting
# kitty = Cat.new
# kitty.class.generic_greeting

# class Cat
#   attr_accessor :name

#   def initialize(name)
#     @name = name
#   end
  
#   def rename(new_name)
#     self.name = new_name # or @name = new_name 
#   end
# end

# kitty = Cat.new('Sophie')
# puts kitty.name
# kitty.rename('Chloe')
# puts kitty.name

# class Cat
#   attr_accessor :name

#   def initialize(name)
#     @name = name
#   end
  
#   def identify
#     self
#   end
# end

# kitty = Cat.new('Sophie')
# p kitty.identify

# class Cat
#   attr_reader :name

#   def initialize(name)
#     @name = name
#   end
  
#   def self.generic_greeting
#     puts "Hello! I'm a cat!"
#   end
  
#   def personal_greeting
#     puts "Hello! My name is #{name}!"
#   end
# end

# kitty = Cat.new('Sophie')

# Cat.generic_greeting
# kitty.personal_greeting

# class Cat
#   @@total_instances = 0
  
#   def initialize
#     @@total_instances += 1
#   end
  
#   def self.total
#     p @@total_instances
#   end
# end


# kitty1 = Cat.new
# kitty2 = Cat.new

# Cat.total

# class Cat
#   COLOR = "purple"
  
#   attr_accessor :name
  
#   def initialize(name)
#     self.name = name
#   end
  
#   def greet
#     puts "Hello! My name is #{name} and I'm a #{COLOR} cat!"
#   end
# end

# kitty = Cat.new('Sophie')
# kitty.greet

# class Cat
#   attr_reader :name

#   def initialize(name)
#     @name = name
#   end
  
#   def to_s
#     "I'm #{name}!"
#   end
# end

# kitty = Cat.new('Sophie')
# puts kitty

# class Person
#   attr_accessor :secret
# end

# person1 = Person.new
# person1.secret = 'Shh.. this is a secret!'
# puts person1.secret

# class Person
#   attr_writer :secret
  
#   def share_secret
#     puts @secret
#   end
  
#   private
#   attr_reader :secret
# end

# person1 = Person.new
# person1.secret = 'Shh.. this is a secret!'
# person1.share_secret

class Person
  attr_writer :secret

  def compare_secret(person)
    self.secret == person.secret
  end

  protected

  attr_reader :secret
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'

person2 = Person.new
person2.secret = 'Shh.. this is a different secret!'

puts person1.compare_secret(person2)
