class MyCar
  attr_accessor :color
  attr_reader :year
  
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
end

honda = MyCar.new(2013, "black", "honda civic")
honda.speed_up
puts honda.color
honda.color = "blue"
puts honda.color
puts honda.year
honda.spray_paint("red")
puts honda.color