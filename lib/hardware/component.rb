module Hardware
  class Component
    def initialize(sensor_collection, actuator_collection)
      @sensor_collection = sensor_collection
      @actuator_collection = actuator_collection
    end
    
    
    def monitor_changes(&block)
      @changed_block = block
    end
    
    protected
    
    def changed
      @changed_block.call if @changed_block
    end
    
    def fire(event)
      @sensor_collection.fire(event)
    end   
    
    def create_sensor_for(event) 
      @sensor_collection.create_sensor_for(event)
    end
    
    def create_actuator_for(event, &block) 
      @actuator_collection.create_actuator_for(event, &block)
    end
  end
  
  class SequencedComponent < Component
    def initialize(sensor_collection, actuator_collection, sequence_number)
      super(sensor_collection, actuator_collection)
      @sequence_number = sequence_number
    end

    protected 
    def fire(event)
      super("#{event}_#{@sequence_number}".to_sym)
    end   

    def create_sensor_for(event) 
      super("#{event}_#{@sequence_number}".to_sym)
    end
    
    def create_actuator_for(event, &block) 
      super("#{event}_#{@sequence_number}".to_sym, &block)
    end
  end
end
