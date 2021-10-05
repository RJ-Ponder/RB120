# # Question 1
# # Alyssa has been assigned a task of modifying a class that was initially created to keep track of secret information. The new requirement calls for adding logging, when clients of the class attempt to access the secret data. Here is the class in its current form:
# class SecretFile
#   attr_reader :log_access

#   def initialize(secret_data, log_entry)
#     @data = secret_data
#     @log_access = log_entry
#     log_entry.create_log_entry
#   end
  
#   def data
#     log_access.create_log_entry
#     @data
#   end
# end

# class SecretFile
#   def initialize(secret_data, logger)
#     @data = secret_data
#     @logger = logger
#   end
  
#   def data
#     @logger.create_log_entry
#     @data
#   end
# end

# # She needs to modify it so that any access to data must result in a log entry being generated. That is, any call to the class which will result in data being returned must first call a logging class. The logging class has been supplied to Alyssa and looks like the following:
# class SecurityLogger
#   def create_log_entry
#     # ... implementation omitted ...
#     puts "data access logged"
#   end
# end

# # Hint: Assume that you can modify the initialize method in SecretFile to have an instance of SecurityLogger be passed in as an additional argument. It may be helpful to review the lecture on collaborator objects for this practice problem.

# log_entry = SecurityLogger.new
# new_file = SecretFile.new("This is a secret", log_entry)
# p new_file.data

# Question 2
module Moveable
  attr_accessor :speed, :heading
  attr_writer :fuel_efficiency, :fuel_capacity

  def range
    @fuel_capacity * @fuel_efficiency
  end
end

class WheeledVehicle
  attr_accessor :speed, :heading
  
  include Moveable
  
  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end

class Auto < WheeledVehicle
  def initialize
    # 4 tires are various tire pressures
    super([30,30,32,32], 50, 25.0)
  end
end

class Motorcycle < WheeledVehicle
  def initialize
    # 2 tires are various tire pressures
    super([20,20], 80, 8.0)
  end
end

class Seacraft
  include Moveable
  attr_reader :propeller_count, :hull_count
  
  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    @propeller_count = num_propellers
    @hull_count = num_hulls
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
  end
  
  def range
    super + 10
  end
end

class Catamaran < Seacraft
end

class Motorboat < Seacraft
  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    super(1, 1, km_traveled_per_liter, liters_of_fuel_capacity)
  end
end

boat = Catamaran.new(2, 2, 10, 10)
boat.fuel_efficiency = 10
p boat.range

car = Auto.new
p car.range