# Below we have 3 classes: Student, Graduate, and Undergraduate. The implementation details for the #initialize methods in Graduate and Undergraduate are missing. Fill in those missing details so that the following requirements are fulfilled:

# Graduate students have the option to use on-campus parking, while Undergraduate students do not.

# Graduate and Undergraduate students both have a name and year associated with them.

# Note, you can do this by adding or altering no more than 5 lines of code.

class StudentBody
  @@student_count = 0
  
  def initialize
    @@student_count += 1
  end
  
  def self.population
    @@student_count
  end
end

class Student < StudentBody
  def initialize(name, year)
    @name = name
    @year = year
    super()
  end
end

class Graduate < Student
  def initialize(name, year, parking)
    super(name, year)
    @parking = parking
  end
end

class Undergraduate < Student # could also use super to pass all arguments
end

# Further Exploration - make a class that uses super(), which calls method with no arguments passed. In order to use the Student example you either have to give default values to name and year so that no arguments doesn't throw an error, or you have to reference a different class that doesn't take arguments as shown here. I couldn't think of a non-trivial example. This is from students Krunal Patel and Matthew Johnston.
