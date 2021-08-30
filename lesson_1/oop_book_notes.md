# The Object Model
**Encapsulation** - hiding pieces of functionality and making it unavailable to the rest of the code base. Includes creating objects and exposing interfaces to interact with those objects.

**Polymorphism** - the ability for different types of data to respond to a common interface.

**Inheritance** - when a class (subclass) inherits the behaviors of another class (superclass). You can define basic classes with large reusability and smaller subclasses for more detailed behaviors.

**Class** - the mold to create or define the attributes and behaviors of an object. They are like the basic outlines of what an object should be made of and what it should be able to do.

**Object** - created or defined from a class. They are things such as numbers, strings, arrays, classes, modules, but not methods, blocks, and variables.

```ruby
# GoodDog is the class
# GoodDog.new returns the object pointed to by the variable, sparky

class GoodDog # define classes with CamelCase
end

sparky = GoodDog.new
```

**Instantiation** - the act of creating a new object or instance from a class (`GoodDog.new`, pointed to by the variable `sparky`)

**Module** - a collection of behaviors that is usable in other classes via mixins. This is another way to achieve polymorphism. Let's say we wanted the `GoodDog` class to have a `speak` method, but there are other classes where we want the speak method, too.

**Mixin** - calls modules into the class functionality with the `include` method invocation

```ruby
module Speak
  def speak(sound)
    puts sound
  end
end

class GoodDog
  include Speak
end

class HumanBeing
  include Speak
end

sparky = GoodDog.new
sparky.speak("Arf!")        # => Arf!
bob = HumanBeing.new
bob.speak("Hello!")         # => Hello!
```

### Exercises
**1. How do we create an object in Ruby? Give an example of the creation of an object.**

An object is created in Ruby by instantiating a new object of the class that it belongs to. The behaviors of the object is defined by the class.

```ruby
class Product
end

hairspray = Product.new
```


**2. What is a module? What is its purpose? How do we use them with our classes? Create a module for the class you created in exercise 1 and include it properly.**

A module is a collection of behaviors that can be shared between classes by mixins. They are reusable chunks of code that can be used to give the same functionality to many different classes. They can be used with classes by being "mixed-in", that is called with the `include` method invocation.

```ruby
module Spray
  def spray(flow_rate, duration)
    puts flow_rate * duration
  end
end

class Product
  include Spray
end

hairspray = Product.new
hairspray.spray(5, 10)
```
# Classes and Objects I
## States and Behaviors
**States** - the attributes or information associated with individual objects.

**Instance Variables** - keep track of state. They are scoped at the object, or instance, level. They tie data to objects and exists as long as the object exists.

**Behaviors** - what objects are capable of doing.

**Instance Methods** - expose behavior for objects. They are available to objects or instances of the class they were defined in.

*Constructor* - a method that gets triggered whenever we create a new object. One such constructor is `initialize`.

**Class Methods** - for example `new` is called on the class to create a new object.

**Accessor Methods** include *getter* methods and *setter* methods. The *getter* method exposes the instance variable and the *setter* method sets it. These methods are the ways to exopse and change an object's state.

*Setter* methods have the syntax `method_name=`. When calling the *setter* method, it doesn't have to look like this: `object.method_name=("argument")`, but can look like this: `object.method_name = "argument"`. 

By convention, *getter* and *setter* methods use the same name as the instance variable they are exposing and setting.

Writing out the *getter* and *setter* methods for every instance variable takes a lot of space and is so commonplace that Ruby has an easier way to create both in one line: `attr_accessor :instance_variable_name`.

If you only want the *getter*: `attr_reader`. If you only want the *setter* `attr_writer`. All `attr_*` methods take a `Symbol` as parameters. If you are tracking more states, you can use this syntax: `attr_accessor :name, :height, :weight`.

**.self** - this method lets you unambiguously call setter methods so it doesn't look like you're just initializing a local variable.

### Exercises
**1. Create a class called MyCar. When you initialize a new instance or object of the class, allow the user to define some instance variables that tell us the year, color, and model of the car. Create an instance variable that is set to `0` during instantiation of the object to track the current speed of the car as well. Create instance methods that allow the car to speed up, brake, and shut the car off.**

```ruby
class MyCar
  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
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
    puts "You are currently driving at #{@current_speed} mph."
  end
end
```

**2. Add an accessor method to your MyCar class to change and view the color of your car. Then add an accessor method that allows you to view, but not modify, the year of your car.**
```ruby
class MyCar
  attr_accessor :color
  attr_reader :year

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
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
    puts "You are currently driving at #{@current_speed} mph."
  end
end
```

**3. You want to create a nice interface that allows you to accurately describe the action you want your program to perform. Create a method called `spray_paint` that can be called on an object and will modify the color of the car.**

```ruby
class MyCar
  attr_accessor :color
  attr_reader :year

  def initialize(year, color, model)
    @year = year     # probably better practice to define accessor methods
    @color = color   # for all these and call the setter with self.variable
    @model = model
    @current_speed = 0
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
    puts "You are currently driving at #{@current_speed} mph."
  end
  
  def spray_paint(new_color)
    self.color = new_color
    puts "Your car has a new #{color} paint job!"
  end
end
```


# Classes and Objects II
**Class Methods** - defined at the class level and can be called on the class itself. Create by prepending with the reserved word `self.`, e.g. `def self.class_method`. These are useful for when you don't have to deal with the state of any object (not needing to use the state of any individual object).

**Class Variables** - variable for the entire class, created with `@@`. You can access class variables from within an instance method.

**Constants** - variables that start with an upper case letter (by convention usually are all-caps), the value for which you don't ever intend to change. It is possible to reassign them but Ruby will throw a warning.

**to_s** - implicitly called with any class using `puts` or string interpolation. In the class level you can change the definition of the to_s method default. You can also do this for the `inspect` method that is called with `p`, but you shouldn't do this because it is useful for debugging.

**self** - this is an important concept in OOP. So far, there are two main use cases: 1) Used in an instance method, `self` references the calling object or instance as if it were on the outside of the class; 2) Used on the class level, it references the class itself and can be used to define class level methods.

### Exercises
**1. Add a class method to your MyCar class that calculates the gas mileage of any car.**
```ruby
class MyCar
  attr_accessor :color
  attr_reader :year

  def initialize(year, color, model)
    @year = year     # probably better practice to define accessor methods
    @color = color   # for all these and call the setter with self.variable
    @model = model
    @current_speed = 0
  end
  
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
    puts "You are currently driving at #{@current_speed} mph."
  end
  
  def spray_paint(new_color)
    self.color = new_color
    puts "Your car has a new #{color} paint job!"
  end
  
  def to_s
    "This car is a #{color} #{year} #{@model}."
  end
end
```
**2. Override the to_s method to create a user friendly print out of your object.**

**3. When running the following code, you get the following error. Why do we get this error and how do we fix it?**

```ruby
class Person
  attr_reader :name
  def initialize(name)
    @name = name
  end
end

bob = Person.new("Steve")
bob.name = "Bob"
```
```ruby
test.rb:9:in `<main>': undefined method `name=' for
  #<Person:0x007fef41838a28 @name="Steve" (NoMethodError)
```

This error is because the accessor method only provides the getter, or reading aspect. The setting aspect is not defined and so there is a NoMethodError for @name=. This can be fixed by either explicitly defining the setter method, or changing `attr_reader` to `attr_accessor`.

# Inheritance
**Class Inheritance** - can subclass from only once class. Use for "is-a" relationships.

**Interface Inheritance** - can mixin as many modules as needed. Use for "has-a" relationships. 

**Method Lookup Path** - the order in which the classes are inspected when you call a method. Think specific to general. object class -> object modules (last to first) -> superclass -> superclass modules -> Object class -> Kernel module -> BasicObject

*Modules** - useful for two other things: 1) *namespacing*, which is organizing classes under a module; and 2) *container* which is to group methods that seem out of place in the code.

**Method Access Control** - *public methods* are available to anyone that knows the class name or object name. *Private methods* are only accessible by other methods in the class. *Protected methods* are accessible from inside the class but are not accessible outside the class. (Basically a hybrid between public and private)

### Exercises
**1. Create a superclass called Vehicle for your MyCar class to inherit from and move the behavior that isn't specific to the MyCar class to the superclass. Create a constant in your MyCar class that stores information about the vehicle that makes it different from other types of Vehicles.**

**Then create a new class called MyTruck that inherits from your superclass that also has a constant defined that separates it from the MyCar class in some way.**

**2. Add a class variable to your superclass that can keep track of the number of objects created that inherit from the superclass. Create a method to print out the value of this class variable as well.**

**3. Create a module that you can mix in to ONE of your subclasses that describes a behavior unique to that subclass.**

**4. Print to the screen your method lookup for the classes that you have created.**

**5. Move all of the methods from the MyCar class that also pertain to the MyTruck class into the Vehicle class. Make sure that all of your previous method calls are working when you are finished.**

**6. Write a method called age that calls a private method to calculate the age of the vehicle. Make sure the private method is not available from outside of the class. You'll need to use Ruby's built-in Time class to help.**

**7. Create a class 'Student' with attributes name and grade. Do NOT make the grade getter public, so joe.grade will raise an error. Create a better_grade_than? method, that you can call like so...**
```ruby
puts "Well done!" if joe.better_grade_than?(bob)
```

**8. Given the following code...**

```ruby
bob = Person.new
bob.hi
```
**And the corresponding error message...**

```ruby
NoMethodError: private method `hi' called for #<Person:0x007ff61dbb79f0>
from (irb):8
from /usr/local/rvm/rubies/ruby-2.0.0-rc2/bin/irb:16:in `<main>'
```
**What is the problem and how would you go about fixing it?**










