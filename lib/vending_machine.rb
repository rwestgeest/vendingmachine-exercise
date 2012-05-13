require 'enum'

class Choice < Enum
  values :cola, :sprite
end

class Can < Enum
  values :cola, :sprite
end

class Bin
  def initialize
    @content = []
  end

  def catch(can)
    @content << can
  end

  def include?(can)
    return @content.include?(can)
  end

  def empty? 
    return @content.empty?
  end
end
class Drawer
  attr_accessor :price
  attr_reader :can
  def initialize(can)
    @can = can
    @price = 0
  end
  
end

class VendingMachine
  def initialize bin
    @bin = bin
    @choices = {} 
    @credits = 0
  end

  def choose(choice)
    @bin.catch(@choices[choice].can) if @choices[choice].price == @credits
  end

  def insert(amount)
    @credits = amount
  end

  def add_choice(choice, can)
    @choices[choice] = Drawer.new(can) 
  end

  def set_price_for(choice, price)
    @choices[choice].price = price
  end

end

