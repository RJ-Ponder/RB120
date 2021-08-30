class Box
  #constructor
  def initialize(width, height)
    @width = width
    @height = height
  end
  
  #getter methods, made private
  def get_width
    @width
  end
  
  def get_height
    @height
  end
  
  protected :get_width, :get_height
  
  def get_area
    get_width * get_height
  end
end

box = Box.new(10, 20)
box.get_width #will raise exception, because private methods cannot be accessed outside of the class
puts box.get_area

# Write about sub classes and protecting methods, private vs protected