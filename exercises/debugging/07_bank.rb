# class BankAccount
#   attr_accessor :balance

#   def initialize(account_number, client)
#     @account_number = account_number
#     @client = client
#     @balance = 0
#   end

#   def deposit(amount)
#     if amount > 0
#       self.balance += amount
#       "$#{amount} deposited. Total balance is $#{balance}."
#     else
#       "Invalid. Enter a positive amount."
#     end
#   end

#   def withdraw(amount)
#     if amount > 0 && amount <= balance
#       self.balance -= amount
#       "$#{amount} withdrawn. Total balance is $#{balance}."
#     else
#       "Invalid. Enter positive amount less than or equal to current balance ($#{balance})."
#     end
#   end

#   # Setter methods always return the value that is passed in as an argument, regardless of what happens inside the method. If the setter tries to return something other than the argument's value, it just ignores that attempt. (OOP Book::Classes and Objects I::Accessor Methods)

#   # def balance=(new_balance)
#   #   if valid_transaction?(new_balance)
#   #     @balance = new_balance
#   #     true
#   #   else
#   #     false
#   #   end
#   # end
  
#   # def valid_transaction?(new_balance)
#   #   new_balance >= 0
#   # end
# end

# # Example

# account = BankAccount.new('5538898', 'Genevieve')

#                           # Expected output:
# p account.balance         # => 0
# p account.deposit(50)     # => $50 deposited. Total balance is $50.
# p account.balance         # => 50
# p account.withdraw(80)    # => Invalid. Enter positive amount less than or equal to current balance ($50).
#                           # Actual output: $80 withdrawn. Total balance is $50.
# p account.balance         # => 50
# p account.withdraw(-50)
# p account.balance

# Further Exploration - from Juliette Sinibardy
# also found this useful resource ->
# https://dev.mikamai.com/2014/06/18/rubyjuice-ruby-setter-methods-gotchas-or-not/

# setter methods can still mutate the original object, so be careful!

class Actor
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def name=(new_name)
    @name = new_name << " the third"
  end
  
  def setter_return
    puts self.name = "test"
  end
end

brad = Actor.new('Brad Pitt')
result = (brad.name = 'Leonardo di Caprio') # return value of the setter

puts result     # => LEONARDO DI CAPRIO
puts brad.name  # => LEONARDO DI CAPRIO
brad.setter_return
