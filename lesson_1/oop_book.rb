class Vehicle
  def self.gas_mileage(miles, gallon)
    puts "#{miles / gallon} mpg"
  end
  
  def speed_up(added_speed = 1)
    @current_speed += added_speed
    puts "You sped up to #{@current_speed} mph!"
  end
  
  def brake(subtracted_speed = 1)
    @current_speed -= subtracted_speed
    puts "You slowed down to #{@current_speed} mph!"
  end
  
  def shut_off
    @current_speed = 0
    puts "You parked and shut the car off."
  end
  
  def current_speed
    puts "You are currently driving at #{current_speed} mph."
  end
end

class MyCar < Vehicle
  attr_accessor :color, :current_speed
  attr_reader :year
  
  STYLE = "sedan"
  
  def initialize(year, color, model)
    @year = year     # probably better practice to define accessor methods
    @color = color   # for all these and call the setter with self.variable
    @model = model
    @current_speed = 0
  end
  
  def spray_paint(new_color)
    self.color = new_color
    puts "Your car has a new #{color} paint job!"
  end
  
  def to_s
    "This #{STYLE} is a #{color} #{year} #{@model}."
  end
end

class MyTruck < Vehicle
  attr_accessor :color
  attr_reader :year
  
  STYLE = "truck"
  
  def initialize(year, color, model)
    @year = year     # probably better practice to define accessor methods
    @color = color   # for all these and call the setter with self.variable
    @model = model
  end
  
  def spray_paint(new_color)
    self.color = new_color
    puts "Your car has a new #{color} paint job!"
  end
  
  def to_s
    "This #{STYLE} is a #{color} #{year} #{@model}."
  end
end

car = MyCar.new(2013, "black", "Honda Civic")
truck = MyTruck.new(1997, "green", "Mazda B4000")
puts car
puts truck
truck.current_speed