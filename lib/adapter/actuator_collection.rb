module Adapter
  class NoActuatorBlockGiven < Exception 
  end
  class DuplicateActuatorException < Exception 
  end
  class NoSuchActuatorException < Exception 
  end
  
  class AsynchronousFirer 
    attr_reader :block
    protected :block
    
    def initialize(&block)
      @block = block
    end
    
    def fire(*params)
      Thread.start { block.call(*params) }
    end
  end
  
  class SynchronousFirer < AsynchronousFirer
    def fire(*params)
      block.call *params
    end
  end
  

  class ActuatorCollection
    class Null
      def create_actuator_for(actuator_name, &block) 
      end
      def fire(actuator_name)
      end
    end
    
    def self.null
      Null.new
    end
    
    def initialize(firer_class = AsynchronousFirer)
      @actuators = {}
      @firer_class = firer_class
    end
    
    def list
      @actuators.entries.collect {|e| e[0].to_s}.sort.collect{|e| e.to_sym}
    end
    
    def create_actuator_for(actuator_name, &block) 
      raise NoActuatorBlockGiven.new("must supply a code block for an actuator - none given") unless block_given?
      raise DuplicateActuatorException.new("actuator :#{actuator_name} already exists") if @actuators.has_key?(actuator_name)
      @actuators[actuator_name.to_sym] = @firer_class.new(&block)
    end
    
    def fire(actuator_name, *params)
      raise NoSuchActuatorException.new("actuator :#{actuator_name} does not exist") unless @actuators.has_key?(actuator_name)
      @actuators[actuator_name.to_sym].fire(*params)
    end
  end
end
