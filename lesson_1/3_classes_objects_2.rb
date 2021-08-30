=begin
1. Add a class method to your MyCar class that calculates the gas mileage of any car.
2. Override the to_s method to create a user friendly print out of your object.
3. When running the following code, we get the following error. Why do we get this error and how do we fix it?
  # a setter method wasn't defined. change attr_reader to attr_accessor or attr_writer
=end
class MyCar
  attr_accessor :color
  attr_reader :year
  
  def self.gas_mileage(miles, gallon)
    puts "This car gets #{miles / gallon} mpg."
  end
  
  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
  end
  
  def speed_up
    @current_speed += 10
    puts "You sped up to #{@current_speed} mph."
  end
  
  def brake
    @current_speed -= 10
    puts "You pressed the brake and slowed to #{@current_speed} mph."
  end
  
  def shut_off
    @current_speed = 0
    puts "You stopped. Let's park the car."
  end
  
  def spray_paint(color)
    self.color = color
    puts "Nice #{@color} paint job!"
  end
  
  def to_s
    puts "This is a #{color} #{year} #{@model}."
  end
end