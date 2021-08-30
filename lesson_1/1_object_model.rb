# 1. How do we create an object in Ruby? Give an example of the creation of an object.
# 2. What is a module? What is its purpose? How do we use them with our classes? Create a module for the class you created in exercise 1 and include it properly.
# A module is a way to group methods or behaviors or classes. They can be mixed in with a class with the include keyword.

module SwitchOn
  def switch_on
    puts "on"
  end
end

class CustomClass
  include SwitchOn
end

object = CustomClass.new
p object
object.switch_on