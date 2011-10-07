module Hardware
  
  class Button < SequencedComponent
    
    def initialize(sensor_collection, sequence_number)
      super(sensor_collection, nil, sequence_number)
    end
    
    def press
      fire(:button_press)
    end
    
    def configure
      create_sensor_for(:button_press)
    end 

  end
end
