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

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
p drawn.count { |card| card.rank == 5 } == 4
p drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
p drawn != drawn2 # Almost always.
