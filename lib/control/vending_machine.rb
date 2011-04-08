require 'enum'

module Control

  class Choice < Enum
    values :cola
  end
   
  class VendingMachine
    def initialize
    end
    def choose(choice)
    end
  end

end
