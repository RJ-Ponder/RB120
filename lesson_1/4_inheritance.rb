class Vehicle
  attr_accessor :color
  attr_reader :year
  
  @@number_of_vehicles = 0
  
  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
    @@number_of_vehicles += 1
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
  
  def self.number_of_vehicles
    puts "There have been #{@@number_of_vehicles} vehicles created."
  end
  
  def self.gas_mileage(miles, gallon)
    puts "This vehicle gets #{miles / gallon} mpg."
  end
  
  def age
    puts "The vehicle is #{years_old} years old."
  end
  
  private
  def years_old
    Time.now.year - self.year.to_i
  end
end

module Utility
  def off_road
    puts "#{@model} going offroad!"
  end
end

class MyCar < Vehicle
  TYPE = "Sedan"
end

class MyTruck < Vehicle
  include Utility
  TYPE = "Truck"
end

# greenie = MyTruck.new(1997, "green", "Mazda B4000")
# blackie = MyCar.new(2013, "black", "Honda Civic")

# Vehicle.number_of_vehicles
# greenie.off_road

# puts "Method Lookup for MyCar:"
# puts blackie.class.ancestors
# puts ""
# puts "Method Lookup for MyTruck:"
# puts greenie.class.ancestors

# greenie.age
# blackie.age

class Student
  attr_accessor :name
  
  def initialize(name, grade)
    @name = name
    @grade = grade
  end
  
  def better_grade_than?(student)
    self.grade > student.grade
  end
  
  protected
  attr_reader :grade
end

joe = Student.new("Joe", 100)
bob = Student.new("Bob", 97)
puts joe.better_grade_than?(bob)