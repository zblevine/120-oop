require 'pry'

class Card
  attr_reader :rank, :card_type

  def initialize(rnk, type)
    @rank = rnk
    @card_type = type
  end

  def value
    case card_type
    when "Number"
      rank
    when "Face"
      10
    when "Ace"
      11
    end
  end

  def to_s
    rank.to_s
  end
end

class Deck
  def initialize
    @cards = []
    reset
  end

  def reset
    (2..10).each { |i| 4.times { @cards << Card.new(i, "Number") } }
    %w(Jack Queen King).each { |i| 4.times { @cards << Card.new(i, "Face") } }
    4.times { @cards << Card.new("Ace", "Ace") }
    @cards.shuffle!
  end

  def deal(guy)
    guy.hand << @cards.shift
  end
end

class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def reset
    cards.clear
  end

  def total
    sum_cards = 0
    cards.each { |card| sum_cards += card.value }
    sum_cards -= 10 * num_aces if sum_cards > 21
    sum_cards
  end

  def to_s
    cards.join(', ')
  end

  def <<(card)
    cards << card
  end

  def first
    cards.first
  end

  private

  def num_aces
    cards.count { |c| c.card_type == 'Ace' }
  end
end

class Person
  BUST_COUNT = 21
  attr_accessor :hand

  def initialize
    @hand = Hand.new
  end

  def busted?
    hand.total > BUST_COUNT
  end
end

class Dealer < Person
  STAY_COUNT = 17

  def first_card
    hand.first
  end

  def must_stay?
    hand.total > STAY_COUNT
  end
end

class TwentyOneGame
  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Person.new
    @dealer = Dealer.new
  end

  def reset_game
    deck.reset
    player.hand.reset
    dealer.hand.reset
  end

  def play
    display_welcome_message
    loop do
      initial_deal
      player_turn
      dealer_turn unless player.busted?
      display_winner
      break unless play_again?
      reset_game
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "Once you go blackjack, you never go back, Jack!"
  end

  def display_goodbye_message
    puts "Until next time . . ."
  end

  def initial_deal
    2.times do
      deck.deal(player)
      deck.deal(dealer)
    end
  end

  def display_hands
    puts "You have: #{player.hand} (#{player.hand.total})"
    puts "Dealer shows: #{dealer.first_card}"
  end

  def display_final_hands
    puts "Your cards: #{player.hand} (#{player.hand.total})"
    puts "Dealer's cards: #{dealer.hand} (#{dealer.hand.total})"
  end

  def hit_or_stay
    choice = ''
    loop do
      puts "Hit or stay? (h/s)"
      choice = gets.chomp.downcase
      break if %w(h s).include?(choice)
      puts "That's not an option. No funny stuff"
    end
    choice
  end

  def player_turn
    loop do
      if player.busted?
        puts "Oh no! You busted!"
        return
      end
      display_hands
      break if hit_or_stay == 's'
      puts "You hit!"
      deck.deal(player)
    end
    puts "You stayed!"
  end

  def dealer_turn
    loop do
      break if dealer.must_stay?
      deck.deal(dealer)
    end

    puts "Ha ha! Dealer busted!" if dealer.busted?
  end

  def display_winner
    display_final_hands
    if dealer.busted?
      puts "You win!"
    elsif player.busted?
      puts "Dealer wins!"
    elsif dealer.hand.total > player.hand.total
      puts "Dealer wins!"
    elsif player.hand.total > dealer.hand.total
      puts "You win!"
    else
      puts "Push!"
    end
  end

  def play_again?
    choice = ''
    loop do
      puts "Play again? (y/n)"
      choice = gets.chomp.downcase
      break if %w(y n).include?(choice)
      puts "Gotta be y/n"
    end
    choice == 'y'
  end
end

gm = TwentyOneGame.new
gm.play
