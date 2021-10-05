# class CircularQueue
#   attr_reader :queue
  
#   def initialize(buffer_size)
#     @buffer_size = buffer_size
#     @queue = [nil] * buffer_size
#   end
  
#   def enqueue(object)
#     queue.shift
#     queue.push(object)
#   end
  
#   def dequeue
#     return_value = nil
#     place = nil
#     queue.each_with_index do |object, index|
#       if object == nil
#         next
#       else
#         return_value = object
#         place = index
#         break
#       end
#     end

#     if return_value == nil
#       return_value
#     else
#       queue.delete_at(place)
#       queue.insert(place, nil)
#       return_value
#     end
#   end
# end

# queue = CircularQueue.new(3)
# puts queue.dequeue == nil

# queue.enqueue(1)
# queue.enqueue(2)
# puts queue.dequeue == 1

# queue.enqueue(3)
# queue.enqueue(4)
# puts queue.dequeue == 2

# queue.enqueue(5)
# queue.enqueue(6)
# queue.enqueue(7)
# puts queue.dequeue == 5
# puts queue.dequeue == 6
# puts queue.dequeue == 7
# puts queue.dequeue == nil

# queue = CircularQueue.new(4)
# puts queue.dequeue == nil

# queue.enqueue(1)
# queue.enqueue(2)
# puts queue.dequeue == 1

# queue.enqueue(3)
# queue.enqueue(4)
# puts queue.dequeue == 2

# queue.enqueue(5)
# queue.enqueue(6)
# queue.enqueue(7)
# puts queue.dequeue == 4
# puts queue.dequeue == 5
# puts queue.dequeue == 6
# puts queue.dequeue == 7
# puts queue.dequeue == nil

class CircularQueue
  def initialize(size)
    @buffer = [nil] * size
    @next_position = 0
    @oldest_position = 0
  end

  def enqueue(object)
    unless @buffer[@next_position].nil?
      @oldest_position = increment(@next_position) # I'd say the argument should be @oldest_position since we want to update the oldest position here when we are replacing it with an object, but this works because the only time we replace something is when the oldest position and next position are the same.
    end

    @buffer[@next_position] = object
    @next_position = increment(@next_position)
  end

  def dequeue
    value = @buffer[@oldest_position]
    @buffer[@oldest_position] = nil
    @oldest_position = increment(@oldest_position) unless value.nil?
    value
  end

  private

  def increment(position)
    (position + 1) % @buffer.size
  end
end

# I didn't need nil as a place holder if using shift, unshift, and pop
# from student Heisenberg
class CircularQueue
  def initialize(size)
    @size = size
    @queue = []
  end

  def enqueue(obj)
    dequeue if full?
    queue.unshift(obj)
  end

  def dequeue
    queue.pop
  end

  private

  def full?
    queue.size == size
  end

  attr_reader :queue, :size
end

queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
queue.enqueue(3)
queue.enqueue(4)

puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil