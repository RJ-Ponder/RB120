require 'pry'
class Shelter
  @@unadopted_pets = []
  
  def initialize
    @owners = []
  end
  
  def self.new_pet(pet)
    @@unadopted_pets << pet
  end
  
  def adopt(owner, pet)
    @owners << owner unless @owners.include?(owner)
    owner.adopt(pet)
    @@unadopted_pets.delete(pet)
  end
  
  def print_adoptions
    @owners.each do |owner|
      puts "#{owner.name} has adopted the following pets:"
      owner.pets.each do |pet|
        puts pet
      end
      puts
    end
  end
  
  def print_unadopted_pets
    if @@unadopted_pets.count == 0
      puts "There are no unadopted pets at the Animal Shelter!"
    else
      puts "The Animal Shelter has the following unadopted pets:"
      puts @@unadopted_pets
    end
    puts
  end
  
  def number_of_unadopted_pets
    @@unadopted_pets.count
  end
end

class Owner
  attr_reader :name, :pets
  
  def initialize(name)
    @name = name
    @pets = []
  end
  
  def adopt(pet)
    @pets << pet
  end
  
  def number_of_pets
    @pets.count
  end
end

class Pet
  attr_reader :type, :name
  
  def initialize(type, name)
    @type = type
    @name = name
    Shelter.new_pet(self)
  end
  
  def to_s
    "a #{type} named #{name}"
  end
end

shelter = Shelter.new

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

asta         = Pet.new('dog', 'Asta')
laddie       = Pet.new('dog', 'Laddie')
fluffy       = Pet.new('cat', 'Fluffy')
kat          = Pet.new('cat', 'Kat')
ben          = Pet.new('cat', 'Ben')
chatterbox   = Pet.new('parakeet', 'Chatterbox')
bluebell     = Pet.new('parakeet', 'Bluebell')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)

shelter.print_adoptions
shelter.print_unadopted_pets
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
puts "The Animal Shelter has #{shelter.number_of_unadopted_pets} unadopted pets."
# P Hanson has adopted the following pets:
# a cat named Butterscotch
# a cat named Pudding
# a bearded dragon named Darwin

# B Holmes has adopted the following pets:
# a dog named Molly
# a parakeet named Sweetie Pie
# a dog named Kennedy
# a fish named Chester

# P Hanson has 3 adopted pets.
# B Holmes has 4 adopted pets.

# Further Exploration
# Add your own name and pets to this project.

# Suppose the shelter has a number of not-yet-adopted pets, and wants to manage them through this same system. Thus, you should be able to add the following output to the example output shown above:

# The Animal Shelter has the following unadopted pets:
# a dog named Asta
# a dog named Laddie
# a cat named Fluffy
# a cat named Kat
# a cat named Ben
# a parakeet named Chatterbox
# a parakeet named Bluebell
#   ...

# P Hanson has 3 adopted pets.
# B Holmes has 4 adopted pets.
# The Animal shelter has 7 unadopted pets.

# Can you make these updates to your solution? Did you need to change your class system at all? Were you able to make all of your changes without modifying the existing interface?