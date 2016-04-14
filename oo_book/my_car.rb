class Vehicle
  attr_accessor :color, :model, :speed
  attr_reader :year, :time_of_creation

  @@number_of_vehicles = 0

  def self.gas_mileage(miles, gal)
    1.0*miles / gal
  end

  def initialize(yr, clr, mdl)
    @year = yr
    @color = clr
    @model = mdl
    @speed = 0
    @@number_of_vehicles += 1
    @time_of_creation = Time.now
  end

  def speed_up(mph)
    self.speed += mph
  end

  def brake(mph)
    self.speed = [0, speed - mph].max
  end

  def shut_down
    self.speed = 0
  end

  def spray_paint(color)
    self.color = color
  end

  def current_speed
    puts speed
  end

  def to_s
    "This vehicle is a #{color} #{year} #{model}"
  end

  def age
    curr_time - time_of_creation
  end

  private

  def curr_time
    Time.now
  end
end

module CanDoDonuts
  def donut
    puts "360, bitches!"
  end
end

class MyCar < Vehicle
  SEATS = 5
  include CanDoDonuts
end

class MyTruck < Vehicle
  SEATS = 7
end

c = MyCar.new(1997, "blue", "honda")
t = MyTruck.new(2005, "black", "hummer")
c.donut
puts c.to_s
puts t.to_s
puts c.year
puts c.age
sleep 2
puts c.age

