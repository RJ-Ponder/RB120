# class Person
#   attr_accessor :name
# end

# person1 = Person.new
# person1.name = 'Jessica'
# puts person1.name

# class Person
#   attr_accessor :name
#   attr_writer :phone_number
# end

# person1 = Person.new
# person1.name = 'Jessica'
# person1.phone_number = '0123456789'
# puts person1.name

# class Person
#   attr_reader :phone_number

#   def initialize(number)
#     @phone_number = number
#   end
# end

# person1 = Person.new(1234567899)
# puts person1.phone_number

# person1.phone_number = 9987654321
# puts person1.phone_number

# class Person
#   attr_accessor :first_name
#   attr_writer :last_name
#   def first_equals_last?
#     first_name == last_name
#   end
#   private
#   attr_reader :last_name
# end

# person1 = Person.new
# person1.first_name = 'Dave'
# person1.last_name = 'Smith'
# puts person1.first_equals_last?

# class Person
#   attr_writer :age
  
#   def older_than?(other)
#     age > other.age
#   end
  
#   protected
#   attr_reader :age
# end

# person1 = Person.new
# person1.age = 17

# person2 = Person.new
# person2.age = 26

# puts person1.older_than?(person2)

# class Person
#   attr_reader :name
  
#   def name=(name)
#     @name = name.capitalize
#   end
# end

# person1 = Person.new
# person1.name = 'eLiZaBeTh'
# puts person1.name

# class Person
#   attr_writer :name
  
#   def name
#     "Mr. #{@name}"
#   end
# end

# person1 = Person.new
# person1.name = 'James'
# puts person1.name

# class Person
#   # attr_reader :name

#   def initialize(name)
#     @name = name
#   end
  
#   def name
#     @name.dup # book uses clone
#   end
# end

# person1 = Person.new('James')
# person1.name.reverse!
# puts person1.name

# class Person
#   def age=(age)
#     @age = age * 2
#   end
  
#   def age
#     @age * 2
#   end
# end

# person1 = Person.new
# person1.age = 20
# puts person1.age


# Modify the following code to accept a string containing a first and last name. The name should be split into two instance variables in the setter method, then joined in the getter method to form a full name.
class Person
  def name=(name)
    parts = name.split
    @first_name = parts.first
    @last_name = parts[1] ? parts.last : ''
  end
  
  def name
    "#{@first_name} #{@last_name}".strip
  end
end

person1 = Person.new
person1.name = 'John Doe'
puts person1.name
