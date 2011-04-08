require 'enum'

class VendingMachine
    def initialize
        @cans = {}
        @cans.default = Can.none
    end
    
    def deliver(choice)
        return @cans[choice]
    end
    
    def configure(choice, can)
        @cans[choice] = can
    end
end

class Can < Enum
    values :none, :cola, :sprite
end

class Choice < Enum
    values :cola, :fanta, :sprite
end

