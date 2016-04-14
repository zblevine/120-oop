require 'pry'

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock'].freeze
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def rock?
    value == 'rock'
  end

  def paper?
    value == 'paper'
  end

  def scissors?
    value == 'scissors'
  end

  def lizard?
    value == 'lizard'
  end

  def spock?
    value == 'spock'
  end

  def >(other_move)
    (rock? && (other_move.scissors? || other_move.lizard?)) ||
      (paper? && (other_move.rock? || other_move.spock?)) ||
      (scissors? && (other_move.paper? || other_move.lizard?)) ||
      (spock? && (other_move.scissors? || other_move.rock?)) ||
      (lizard? && (other_move.spock? || other_move.paper?))
  end
end

class Player
  attr_accessor :move, :name, :score, :move_history

  def initialize
    set_name
    self.score = 0
    self.move_history = []
  end
end

class Human < Player
  def set_name
    my_name = ''
    loop do
      puts "What's your name?"
      my_name = gets.chomp
      break unless my_name.empty?
      puts "Blank is not a name"
    end
    self.name = my_name
  end

  def choose
    choice = ''
    loop do
      puts "Rock, paper, scissors, lizard, or spock?"
      choice = gets.chomp.downcase
      break if Move::VALUES.include? choice
      puts "Not a choice"
    end
    self.move = Move.new(choice)
    move_history << self.move.value
  end
end

class Computer < Player
  def set_name
    self.name = "Gary Oak"
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
    move_history << self.move.value
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to RPS! First to ten wins!"
  end

  def display_goodbye_message
    puts "Exiting game . . ."
  end

  def display_moves
    puts "#{human.name} chose #{human.move.value}"
    puts "#{computer.name} chose #{computer.move.value}"
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif computer.move > human.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def update_score
    human.score += 1 if human.move > computer.move
    computer.score += 1 if computer.move > human.move
  end

  def display_score
    puts "\n"
    puts "SCORE:"
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
    puts "#{human.name} is the winner!" if human.score == 10
    puts "#{computer.name} is the winner!" if computer.score == 10
    puts "\n"
  end

  def print_array(a)
    print "["
    a.each_with_index do |s, i|
      print s
      print ", " unless i == a.size - 1
    end
    print "]\n"
  end

  def display_move_histories
    print "#{human.name}'s moves: "
    print_array(human.move_history)
    print "#{computer.name}'s moves: "
    print_array(computer.move_history)
    puts
  end

  def play_again?
    answer = ''
    loop do
      puts "Play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      puts "Not a choice"
    end

    return true if answer == 'y'
    false
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      update_score
      display_score
      display_move_histories
      break if human.score == 10 || computer.score == 10
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
