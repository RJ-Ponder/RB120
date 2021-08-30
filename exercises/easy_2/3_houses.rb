class House
  attr_reader :price
  
  include Comparable
  
  def initialize(price)
    @price = price
  end
  
  def <=>(object)
    self.price <=> object.price
  end
end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2
puts "Home 2 is more expensive" if home2 > home1

# This may not be the most ideal way to define comparisons between houses. Other factors like size (Sqft.), condition, year built, etc. may be more applicable.