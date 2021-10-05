class Card
  include Comparable
  
  attr_reader :rank, :suit, :number_rank

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @number_rank = number_rank
  end
  
  def number_rank
    case rank
    when "Jack" then 11
    when "Queen" then 12
    when "King" then 13
    when "Ace" then 14
    else
      rank
    end
  end

  def <=>(other)
    number_rank <=> other.number_rank
  end
  
  def to_s
    "#{rank} of #{suit}"
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze
  
  def initialize
    @deck = []
    shuffle_deck
  end
  
  def shuffle_deck
    RANKS.each do |rank|
      SUITS.each do |suit|
        @deck << Card.new(rank, suit)
      end
    end
    @deck = @deck.shuffle
  end

  def draw
    shuffle_deck if @deck.empty?
    @deck.pop
  end
end

class PokerHand
  def initialize(deck)
    @hand = []
    draw_hand(deck)
  end
  
  def draw_hand(deck)
    5.times { @hand << deck.draw }
  end
  
  def print
    puts @hand
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def royal_flush?
    flush? && straight? && @hand.min.rank == 10
  end

  def straight_flush?
    flush? && straight?
  end

  def four_of_a_kind?
    ranks = @hand.map { |card| card.number_rank }
    ranks.each do |rank|
      return true if ranks.count(rank) == 4
    end
    false
  end

  def full_house?
    unique_ranks = @hand.map { |card| card.number_rank }.uniq
    three_of_a_kind? && unique_ranks.count == 2
  end

  def flush?
    @hand.map { |card| card.suit }.uniq.count == 1
  end

  def straight?
    sorted = @hand.map { |card| card.number_rank }.sort
    difference = []
    (0..3).each do |index|
      difference << sorted[index + 1] - sorted[index]
    end
    difference.uniq.count == 1
  end

  def three_of_a_kind?
    ranks = @hand.map { |card| card.number_rank }
    ranks.each do |rank|
      return true if ranks.count(rank) == 3
    end
    false
  end

  def two_pair?
    unique_ranks = @hand.map { |card| card.number_rank }.uniq
    pair? && unique_ranks.count == 3
  end

  def pair?
    ranks = @hand.map { |card| card.number_rank }
    ranks.each do |rank|
      return true if ranks.count(rank) == 2
    end
    false
  end
end

hand = PokerHand.new(Deck.new)
system 'clear'
hand.print
gets.chomp
puts hand.evaluate

# # Danger danger danger: monkey patching for testing purposes.
# class Array
#   alias_method :draw, :pop
# end

# # Test that we can identify each PokerHand type.
# hand = PokerHand.new([
#   Card.new(10,      'Hearts'),
#   Card.new('Ace',   'Hearts'),
#   Card.new('Queen', 'Hearts'),
#   Card.new('King',  'Hearts'),
#   Card.new('Jack',  'Hearts')
# ])
# puts hand.evaluate == 'Royal flush'

# hand = PokerHand.new([
#   Card.new(8,       'Clubs'),
#   Card.new(9,       'Clubs'),
#   Card.new('Queen', 'Clubs'),
#   Card.new(10,      'Clubs'),
#   Card.new('Jack',  'Clubs')
# ])
# puts hand.evaluate == 'Straight flush'

# hand = PokerHand.new([
#   Card.new(3, 'Hearts'),
#   Card.new(3, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(3, 'Spades'),
#   Card.new(3, 'Diamonds')
# ])
# puts hand.evaluate == 'Four of a kind'

# hand = PokerHand.new([
#   Card.new(3, 'Hearts'),
#   Card.new(3, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(3, 'Spades'),
#   Card.new(5, 'Hearts')
# ])
# puts hand.evaluate == 'Full house'

# hand = PokerHand.new([
#   Card.new(10,     'Hearts'),
#   Card.new('Ace',  'Hearts'),
#   Card.new(2,      'Hearts'),
#   Card.new('King', 'Hearts'),
#   Card.new(3,      'Hearts')
# ])
# puts hand.evaluate == 'Flush'

# hand = PokerHand.new([
#   Card.new(8,      'Clubs'),
#   Card.new(9,      'Diamonds'),
#   Card.new(10,     'Clubs'),
#   Card.new(7,      'Hearts'),
#   Card.new('Jack', 'Clubs')
# ])
# puts hand.evaluate == 'Straight'

# hand = PokerHand.new([
#   Card.new('Queen', 'Clubs'),
#   Card.new('King',  'Diamonds'),
#   Card.new(10,      'Clubs'),
#   Card.new('Ace',   'Hearts'),
#   Card.new('Jack',  'Clubs')
# ])
# puts hand.evaluate == 'Straight'

# hand = PokerHand.new([
#   Card.new(3, 'Hearts'),
#   Card.new(3, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(3, 'Spades'),
#   Card.new(6, 'Diamonds')
# ])
# puts hand.evaluate == 'Three of a kind'

# hand = PokerHand.new([
#   Card.new(9, 'Hearts'),
#   Card.new(9, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(8, 'Spades'),
#   Card.new(5, 'Hearts')
# ])
# puts hand.evaluate == 'Two pair'

# hand = PokerHand.new([
#   Card.new(2, 'Hearts'),
#   Card.new(9, 'Clubs'),
#   Card.new(5, 'Diamonds'),
#   Card.new(9, 'Spades'),
#   Card.new(3, 'Diamonds')
# ])
# puts hand.evaluate == 'Pair'

# hand = PokerHand.new([
#   Card.new(2,      'Hearts'),
#   Card.new('King', 'Clubs'),
#   Card.new(5,      'Diamonds'),
#   Card.new(9,      'Spades'),
#   Card.new(3,      'Diamonds')
# ])
# puts hand.evaluate == 'High card'

# Further Exploration
# The following questions are meant to be thought exercises; rather than write code, think about what you would need to do. Feel free to write some code after thinking about the problem.

# How would you modify this class if you wanted the individual classification methods (royal_flush?, straight?, three_of_a_kind?, etc) to be public class methods that work with an Array of 5 cards, e.g.,

# def self.royal_flush?(cards)
#   ...
# end

# I didn't understand why you would want this or what it would even look like, but got some help from Alexandre Mercier from user submitted solutions.
# def self.royal_flush?(cards)
  # implementation
# end

# doing the above would let you call the method directly on the class PokerHand and pass in an array of 5 cards.
# for example
# hand = [
#   Card.new(10,      'Hearts'),
#   Card.new('Ace',   'Hearts'),
#   Card.new('Queen', 'Hearts'),
#   Card.new('King',  'Hearts'),
#   Card.new('Jack',  'Hearts')
# ]
# puts PokerHand.royal_flush?(hand)

# still really not sure why you would want to do this though



# How would you modify our original solution to choose the best hand between two poker hands?
# need to also test for the high card when there is a tie
# Rules for ties:
  # same 5 card hand is a tie
  # no pair: highest non-tie card
  # one pair: next highest non-tie card
  # two pair: higher pair or higher 5th card (kicker) if same two pairs
  # three of a kind: higher 3 of a kind or high kicker
  # straight/flush: high card wins
  # full house: highest trips, then pair, then tie
  # four of a kind: highest
  # straight flush: top wins
  # royal flush: only possible if on the board, tie
# How would you modify our original solution to choose the best 5-card hand from a 7-card poker hand?
# 21 5-card combinations out of a 7 card hand. find the best of the 21
