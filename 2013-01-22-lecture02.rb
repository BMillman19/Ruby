## Methods

class MyClass
    def method1    # default is 'public'
      "method1"
    end
  protected          # subsequent methods will be 'protected'
    def method2    # will be 'protected'
      "method2"
    end
  private            # subsequent methods will be 'private'
    def method3    # will be 'private'
      "method3"
    end
  public             # subsequent methods will be 'public'
    def method4    # and this will be 'public'
      "method4"
    end
end

class MyClass
  def method1
    "new method1"
  end
  # ... and so on

  public    :method1, :method4
  protected :method2
  private   :method3
end

a = MyClass.new

puts a.method1 # => new method1
# puts a.method2 # => protected method `method2' called for ... (NoMethodError)
# puts a.method3 # => private method `method3' called  for ... (NoMethodError)
puts a.method4 # => method4

## Variables

class Person
  attr :age
  attr_reader :age
  # gets translated into:
  def age
    @age
  end

  attr_writer :age
  # gets translated into:
  def age=(value)
    @age = value
  end

  # attr_accessor :age gets will generate both of the methods above
end

## Variable Encapsulation
class Base
  def initialize()
    @x = 10
  end
end

d = Base.new
# puts d.x # => undefined method `x' for ... (NoMethodError)
puts d.instance_variable_get :@x # => 10

## Class Variable
module T
  @@foo = 'bar'

  def self.set(x)
    @@foo = x
  end

  def self.get
    @@foo
  end
end

p T.get         # => 'bar'
T.set('fubar')
p T::get        # => 'fubar'

## Inheritance

class Base
  def initialize()
    @x = 10
  end
end

class Derived < Base
  def x
    @x = 20
  end
end

d = Derived.new
p d.x # => 20

## Tree Implementation

class Tree
  # Define instance variables children and node_name, and the associated getters and setters
  attr_accessor :children, :node_name

  # Define a constructor with 2 parameters, with the second having a default value
  def initialize(name, children=[])
    @children = children
    @node_name = name
  end

  # Uses code blocks
  def visit_all(&block)
    visit &block
    children.each {|c| c.visit_all &block}
  end

  # Uses code blocks
  def visit(&block)
    block.call self
  end
end

tree = Tree.new("root", [
  Tree.new('child_a'),
  Tree.new('child_b'),
  Tree.new('child_c', [
    Tree.new('child_d', [
      Tree.new('child_e')
    ]),
    Tree.new('child_f')
  ])
])

puts "visit single node"
tree.visit {|node| puts node.node_name}

puts "visit tree"
tree.visit_all {|node| puts node.node_name}

# Output:
# visit single node
# root
# visit tree
# root
# child_a
# child_b
# child_c
# child_d
# child_e
# child_f

# ---------------------------------------------------------------------------- #

## Module Example
module ToFile
  def filename
    "object_#{self.object_id}.txt"
  end
  def to_f
    File.open(filename, 'w') {|f| f.write(to_s)}
  end
end
class Person
  include ToFile
  attr_accessor :name
  def initialize(name)
    @name = name
  end
  def to_s
    name
  end
end
Person.new('Kevin').to_f

# ---------------------------------------------------------------------------- #

## Comparable

'begin' <=> 'end' # => -1
'same' <=> 'same' # => 0

## Sorting Example
class SizeMatters
  include Comparable
  attr :str
  def <=>(anOther)
    str.size <=> anOther.str.size
  end
  def initialize(str)
    @str = str
  end
  def inspect
    @str
  end
end

[
  SizeMatters.new("S"),
  SizeMatters.new("SSSS"),
  SizeMatters.new("SSSSS"),
  SizeMatters.new("SS"),
  SizeMatters.new("SSS")
].sort

# => [S, SS, SSS, SSSS, SSSSS]

# ---------------------------------------------------------------------------- #

## Enumerable

a = [5, 3, 4, 1]

a.sort # => [1, 3, 4, 5]

a.any? {|i| i > 6} # => false
a.any? {|i| i > 4} # => true

a.all? {|i| i > 4} # => false
a.all? {|i| i > 0} # => true

a.collect {|i| i * 2} # => [10, 6, 8, 2]

a.select {|i| i % 2 == 0 } # even => [4]
a.select {|i| i % 2 == 1 } # odd => [5, 3, 1]

a.max # => 5
a.member?(2) # => false

a = [5, 3, 4, 1]
a.inject(0) {|sum, i| sum + i}
# => 13
a.inject {|sum, i| sum + i}
# => 13
a.inject {|product, i| product * i}
# = 560
a.inject(0) do |sum, i|
 puts "sum: #{sum} i: #{i} sum + i: #{sum + i}"
 sum + i
end
# sum:0 i:5 sum+i:5
# sum:5 i:3 sum+i:8
# sum:8 i:4 sum+i:12
# sum:12 i:1 sum+i:13

# ---------------------------------------------------------------------------- #

## Open Classes
class NilClass
  def blank?
    true
  end
end

class String
  def blank?
    self.size == 0
  end
end

["", "person", nil].each do |element|
  puts element unless element.blank?
end

# ---------------------------------------------------------------------------- #

## method_missing

class Roman
  def self.method_missing name, *args
    roman = name.to_s
    roman.gsub!("IV", "IIII")
    roman.gsub!("IX", "VIIII")
    roman.gsub!("XL", "XXXX")
    roman.gsub!("XC", "LXXXX")
    (roman.count("I") + roman.count("V")*5 + roman.count("X")*10
     + roman.count("L")*50 + roman.count("C")*100)
  end
end
puts Roman.X    # 10
puts Roman.XC   # 90
puts Roman.XII  # 12
puts Roman.IX   # 9

# ---------------------------------------------------------------------------- #

## The inheritance/macro approach

class Person
  attr_accessor :name
  def self.can_speak  # This is a class method! Notice the self.
    define_method 'speak' do  # an instance method
      puts "I can talk, my name is #{@name}!"
    end
  end

  def initialize(name)
    @name = name
  end
end

class Guy < Person
  can_speak
end

class ShyGuy < Person
end

john = Guy.new('John')
bob = ShyGuy.new('Bob')
john.methods.include?(:speak)   # true
bob.methods.include?(:speak)    # false

# ---------------------------------------------------------------------------- #

## The module approach

module Person
  attr_accessor :name
  def self.included(base) # included is invoked whenever a module is included; base is implicit
    base.extend ClassMethods  # extend will add the methods defined in ClassMethods as class methods
  end
  module ClassMethods
    def can_speak
      include InstanceMethods # This includes all the instance methods
    end
  end
  module InstanceMethods
    def speak
      puts "I can talk, my name is #{@name}!"
    end
  end
  def initialize(name)
    @name = name
  end
end

class Guy
  include Person
  can_speak
end

class ShyGuy
  include Person
end

john = Guy.new('John')
bob = ShyGuy.new('Bob')
john.methods.include?(:speak)   # true
bob.methods.include?(:speak)    # false
