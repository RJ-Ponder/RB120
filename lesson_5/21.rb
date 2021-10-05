class Participant
  BUST_LIMIT = 21

  attr_accessor :cards

  def initialize
    @cards = []
  end

  def total
    card_ranks = cards.map(&:rank)
    no_aces = card_ranks.reject { |rank| rank == 'A' }
    no_aces_total = no_aces.map { |rank| rank.to_i <= 1 ? 10 : rank.to_i }.sum
    number_of_aces = card_ranks.count('A')
    max_total(no_aces_total, number_of_aces)
  end

  def max_total(no_aces_total, number_of_aces)
    aces_as_one = 0
    total = nil
    loop do
      total = no_aces_total + (number_of_aces - aces_as_one) * 11 + aces_as_one
      break if total <= BUST_LIMIT || aces_as_one >= number_of_aces
      aces_as_one += 1
    end
    total
  end

  def busted?
    total > BUST_LIMIT
  end
end

class Dealer < Participant; end

class Player < Participant; end

class Deck
  RANKS = ((2..9).to_a + %w(T J Q K A)).freeze
  SPADES = "\u2660"
  HEARTS = "\u2665"
  CLUBS = "\u2663"
  DIAMONDS = "\u2666"
  SUITS = [SPADES.to_s, HEARTS.to_s, CLUBS.to_s, DIAMONDS.to_s].freeze

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

  def deal(number_of_cards)
    hand = []
    number_of_cards.times do
      shuffle_deck if @deck.empty?
      hand << @deck.pop
    end
    hand
  end
end

class Card
  include Comparable

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @number_rank = number_rank
  end

  def number_rank
    if %w(T J Q K).include?(rank)
      10
    elsif rank == "A"
      11
    else
      rank
    end
  end

  def to_s
    "|#{rank}#{suit}|"
  end
end

class Game
  BUST_LIMIT = 21
  WINNING_SCORE = 20
  DEALER_LIMIT = 17

  attr_reader :dealer, :player, :deck
  attr_accessor :score

  def initialize
    @dealer = Dealer.new
    @player = Player.new
    @deck = Deck.new
  end

  def prompt(msg, delay_seconds = 0)
    puts "=> #{msg}"
    sleep(delay_seconds)
  end

  def start
    welcome_and_rules
    loop do
      reset
      loop do
        reset_cards
        deal_hands
        show_initial_cards
        player_turn
        dealer_turn unless player.busted?
        show_result
        tally_score
        display_score
        break if champion?
        break unless play_another_hand?
      end
      display_champion if champion?
      break unless play_another_game?
    end
    goodbye_message
  end

  def welcome_and_rules
    system 'clear'
    prompt "Welcome to #{BUST_LIMIT}!", 1
    puts
    prompt "Win #{WINNING_SCORE} hands before the dealer to become Champion.", 1
    prompt "Win a hand by scoring higher than the dealer without going over"\
    " #{BUST_LIMIT}.", 1
    puts
    prompt 'Press enter to continue.'
    STDIN.gets
  end

  def reset
    deck.shuffle_deck
    @hand_count = 0
    @score = { player: 0, dealer: 0, pushed: 0 }
  end

  def reset_cards
    dealer.cards = []
    player.cards = []
  end

  def deal_hands
    dealing_message
    dealer.cards += deck.deal(2)
    player.cards += deck.deal(2)
  end

  def dealing_message
    @hand_count += 1
    system 'clear'
    prompt "Dealing the #{ordinal_number} hand...", 1.5
  end

  def ordinal_number
    count = @hand_count.to_s
    if count[-2] == '1'
      count + 'th'
    elsif count[-1] == '1'
      count + 'st'
    elsif count[-1] == '2'
      count + 'nd'
    elsif count[-1] == '3'
      count + 'rd'
    else
      count + 'th'
    end
  end

  def show_initial_cards
    system 'clear'
    show_initial_dealer_cards
    show_player_cards
    puts
  end

  def show_initial_dealer_cards
    puts "Dealer:"
    puts "+--+ " * dealer.cards.length
    puts "|??| #{dealer.cards[1]}"
    puts "+--+ " * dealer.cards.length
  end

  def show_player_cards
    puts "Player:"
    puts "+--+ " * player.cards.length
    puts "#{player.cards.join(' ')} Total: #{player.total}"
    puts "+--+ " * player.cards.length
  end

  def show_all_cards
    system 'clear'
    show_dealer_cards
    show_player_cards
    puts
  end

  def show_dealer_cards
    puts "Dealer:"
    puts "+--+ " * dealer.cards.length
    puts "#{dealer.cards.join(' ')} Total: #{dealer.total}"
    puts "+--+ " * dealer.cards.length
  end

  def player_turn
    loop do
      decision = player_hit_or_stay
      if decision == "h"
        player.cards += deck.deal(1)
        show_initial_cards
        prompt "You chose to hit.", 1
        break player_busted if player.busted?
      else
        puts "You chose to stay."
        break
      end
    end
  end

  def player_hit_or_stay
    prompt "Hit or Stay?"
    valid_answers = %w(h hit s stay)
    answer = nil
    loop do
      answer = gets.chomp.strip.downcase
      break if valid_answers.include?(answer)
      puts "Please choose either to (H)it or (S)tay."
    end
    answer[0]
  end

  def player_busted
    prompt "You busted!", 1
    prompt "Revealing dealer card...", 1.5
    show_all_cards
  end

  def dealer_turn
    prompt "Dealer's turn. Revealing card...", 1
    show_all_cards
    sleep(1.5)
    loop do
      if dealer.total < DEALER_LIMIT
        dealer.cards += deck.deal(1)
        prompt 'Dealer hits.', 0.33
        prompt '.', 0.33
        prompt '..', 0.33
        prompt '...', 0.33
        show_all_cards
      end

      break if dealer.total >= DEALER_LIMIT
    end
    prompt "Dealer stays.", 1 unless dealer.busted?
    prompt "Dealer busted!", 1 if dealer.busted?
  end

  def show_result
    if player.busted?
      prompt "You lost the hand."
    elsif dealer.busted?
      prompt "You won the hand!"
    elsif player.total > dealer.total
      prompt "You won the hand!"
    elsif player.total < dealer.total
      prompt "You lost the hand."
    else
      prompt "It's a push."
    end
  end

  def tally_score
    if player.busted?
      @score[:dealer] += 1
    elsif dealer.busted?
      @score[:player] += 1
    elsif player.total > dealer.total
      @score[:player] += 1
    elsif player.total < dealer.total
      @score[:dealer] += 1
    else
      @score[:pushed] += 1
    end
  end

  def display_score
    prompt "Score: You - #{@score[:player]}, Dealer - #{@score[:dealer]}," \
    " Pushes - #{@score[:pushed]}"
  end

  def champion?
    @score[:dealer] == WINNING_SCORE || @score[:player] == WINNING_SCORE
  end

  def display_champion
    if @score[:dealer] == WINNING_SCORE
      prompt "The dealer is the champion!"
    else
      prompt "You are the champion!"
    end
  end

  def play_another_hand?
    prompt "Play another hand? (y/n)"
    answer = nil
    loop do
      answer = gets.chomp.strip.downcase
      break if %w(y yes n no).include?(answer)
      prompt "Please choose y or n."
    end
    answer[0] == 'y'
  end

  def play_another_game?
    prompt "Play another game? (y/n)"
    answer = nil
    loop do
      answer = gets.chomp.strip.downcase
      break if %w(y yes n no).include?(answer)
      prompt "Please choose y or n."
    end
    answer[0] == 'y'
  end

  def goodbye_message
    prompt "Thanks for playing #{BUST_LIMIT}! Goodbye!"
  end
end

Game.new.start
