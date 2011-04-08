require 'enum'

module Control
  class Can < Enum
    values :nothing, :cola, :fanta, :sprite
  end

  class Choice < Enum
    values :cola, :fanta, :sprite
  end
  
  class Drawer
    def initialize(can, price)
      @can = can
      @price = price
    end
    def deliver(credits)
      if (@price == credits)
        return @can
      end 
      return Can.nothing
    end
  end

  class VendingMachine
    def initialize
      @choices = {}
      @choices.default = Drawer.new(Can.nothing, 0)
      @credits= 0
    end

    def deliver(choice)
      drawer = @choices[choice]
      return drawer.deliver(@credits)
    end
  
    def insert(amount)
      @credits = amount
    end
    
    def add_choice(choice, can, price)
      @price = price
      @choices[choice] = Drawer.new(can, price)
    end
  end
end
