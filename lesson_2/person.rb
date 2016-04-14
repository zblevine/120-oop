class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    parse_full_name(full_name)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def name=(full_name)
    parse_full_name(full_name)
  end

  private

  def parse_full_name(full_name)
    sp = full_name.split
    self.first_name = sp[0]
    self.last_name = sp.size > 1 ? sp.last : ''
  end

  def to_s
    name
  end

end

bob = Person.new('Robert Paulson')
rob = Person.new('Robert Paulson')
puts name.ancestors