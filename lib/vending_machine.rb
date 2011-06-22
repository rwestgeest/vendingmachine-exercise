require 'enum'

class Choice < Enum
  values :cola, :fanta
end

class Can < Enum
  values :nothing, :cola, :fanta
end

class VendingMachine
  def initialize
    @drawers = {}
    @drawers.default = Can.nothing
  end

  def add_choice(choice, can)
    @drawers[choice] = can
  end

  def deliver(choice)
    return @drawers[choice]
  end
end
