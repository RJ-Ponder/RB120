# # Now that we have a Walkable module, we are given a new challenge. Apparently some of our users are nobility, and the regular way of walking simply isn't good enough. Nobility need to strut.

# # We need a new class Noble that shows the title and name when walk is called:
# module Walkable
#   def walk
#     "#{name} #{gait} forward"
#   end
# end

# class Person
#   include Walkable
  
#   attr_reader :name

#   def initialize(name)
#     @name = name
#   end

#   private

#   def gait
#     "strolls"
#   end
# end

# class Cat
#   include Walkable
  
#   attr_reader :name

#   def initialize(name)
#     @name = name
#   end

#   private

#   def gait
#     "saunters"
#   end
# end

# class Cheetah
#   include Walkable
  
#   attr_reader :name

#   def initialize(name)
#     @name = name
#   end

#   private

#   def gait
#     "runs"
#   end
# end

# class Noble
#   include Walkable
  
#   attr_reader :name, :title
  
#   def initialize(name, title)
#     @name = name
#     @title = title
#   end
  
#   def walk
#     "#{title} " + super
#   end
  
#   private
  
#   def gait
#     "struts"
#   end
# end

# mike = Person.new("Mike")
# p mike.walk
# # => "Mike strolls forward"

# kitty = Cat.new("Kitty")
# p kitty.walk
# # => "Kitty saunters forward"

# flash = Cheetah.new("Flash")
# p flash.walk
# # => "Flash runs forward"

# byron = Noble.new("Byron", "Lord")
# p byron.walk
# # => "Lord Byron struts forward"

# # We must have access to both name and title because they are needed for other purposes that we aren't showing here.

# p byron.name
# # => "Byron"
# p byron.title
# # => "Lord"

# # Further Exploration
# # This exercise can be solved in a similar manner by using inheritance; a Noble is a Person, and a Cheetah is a Cat, and both Persons and Cats are Animals. What changes would you need to make to this program to establish these relationships and eliminate the two duplicated #to_s methods?

module Walkable
  def walk
    "#{name} #{gait} forward"
  end
end

class Mammal
  attr_reader :name

  include Walkable
  
  def initialize(name)
    @name = name
  end
  
  def to_s
    name
  end
end

class Person < Mammal
  private

  def gait
    "strolls"
  end
end

class Cat < Mammal
  private

  def gait
    "saunters"
  end
end

class Cheetah < Cat
  private

  def gait
    "runs"
  end
end

class Noble < Person
  attr_reader :title
  
  def initialize(name, title)
    super(name)
    @title = title
  end
  
  def to_s
    "#{title} #{name}"
  end
  
  private
  
  def gait
    "struts"
  end
end

mike = Person.new("Mike")
p mike.walk
# => "Mike strolls forward"

kitty = Cat.new("Kitty")
p kitty.walk
# => "Kitty saunters forward"

flash = Cheetah.new("Flash")
p flash.walk
# => "Flash runs forward"

byron = Noble.new("Byron", "Lord")
p byron.walk
# => "Lord Byron struts forward"

p byron.name
# => "Byron"
p byron.title
# => "Lord"

# I prefer calling super and adding the title rather than using to_s in this case. You could also change to a manual getter to include the title in name. The tradeoff is that the full title and name will be displayed anytime you call name.