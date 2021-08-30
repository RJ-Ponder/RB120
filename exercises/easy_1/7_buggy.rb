class Car
  attr_accessor :mileage

  def initialize
    @mileage = 0
  end

  def increment_mileage(miles)
    total = mileage + miles # mileage here is calling the getter method
    self.mileage = total # you could use the instance variable directly, but it is safer to call the setter method in case there are any checks or modificaitons. 
  end

  def print_mileage
    puts mileage
  end
end

car = Car.new
car.mileage = 5000
car.increment_mileage(678)
car.print_mileage  # should print 5678