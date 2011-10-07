module Adapter
  class Sensor
    def fire
      @on_fire_block.call if @on_fire_block
    end
    def on_fire_do(&block)
      @on_fire_block = block
    end
    def remove_fire_listener
      @on_fire_block = nil
    end
  end
  
  class NoSuchSensorException < Exception 
  end
  
  class SensorCollection
    class Null
      def on(sensor)
      end
      def create_sensor_for(event)
      end
      def fire(sensor)
      end
    end
    
    def initialize
      @sensors = {}
      @sensors.default = Sensor.new
    end
    
    def self.null
      Null.new 
    end 
    
    def list
      @sensors.entries.collect { |e| e[0].to_s }.sort.collect{ |e| e.to_sym }
    end
    
    def on(sensor, &block)
      raise NoSuchSensorException.new("sensor :#{sensor} does not exist") unless @sensors.has_key?(sensor.to_sym)
      @sensors[sensor.to_sym].on_fire_do(&block) 
    end
    
    def create_sensor_for(event)
      @sensors[event.to_sym] = Sensor.new    
    end
    
    def fire(sensor)
      @sensors[sensor.to_sym].fire
    end

    def remove_fire_listeners
      @sensors.collect {|name, sensor| sensor.remove_fire_listener } 
    end
  end
end
