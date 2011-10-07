module Hardware
  class Drawer < SequencedComponent
    attr_reader :stock
    
    def initialize(bin, 
                   sensor_collection = Adapter::SensorCollection.null, 
                   actuator_collection = Adapter::ActuatorCollection.null, 
                   sequence_number = 0)
      super(sensor_collection, actuator_collection, sequence_number)
      @bin = bin
      @stock = []
    end

    def fill(can_type, stock, time_it_takes_per_can = 1)
      stock.times do
        @stock << can_type
        fire(:drawer_fill_can) 
      end
      self
    end
    
    def drop(time_it_takes = 3)
      return if @stock.empty?
      fire(:drawer_drop_can)
      sleep(time_it_takes)
      @bin.receive(@stock.shift)
    end
    
    def configure
      create_sensor_for(:drawer_drop_can)
      create_sensor_for(:drawer_fill_can)
      create_actuator_for(:drawer_drop_can) do
        self.drop
      end
    end

    def empty?
      @stock.empty?
    end

    def reset
      @stock.clear
    end
  end
end
