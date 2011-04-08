require File.join(File.dirname(__FILE__),'..','test_helper')
require 'hardware_adapter'

module Adapter

  class SensorCollectionFireTest  < Test::Unit::TestCase
    attr_reader :sensors
    def setup
      @sensors = SensorCollection.new
      sensors.create_sensor_for(:bin_entry)
    end
    
    def test_list_lists_sensor
      sensors.create_sensor_for(:something_entry)
      assert_equal [:bin_entry, :something_entry], sensors.list
    end
    
    def test_calls_block_given_for_a_sensor
      bin_entry_fired = false
      sensors.on(:bin_entry) do
        bin_entry_fired = true
      end
      sensors.fire(:bin_entry)
      assert bin_entry_fired, "bin_entry should be fired"
    end
    
    def test_swallows_fire_silently_when_no_handler_defined
      sensors.fire(:bin_entry) 
    end
    
  end
  
  class SensorCollectionFireWithoutReceptorsCreatedTest  < Test::Unit::TestCase
    attr_reader :sensors
    def setup
      @sensors = SensorCollection.new
    end
    
    def test_swallows_fire_silently_when_no_handler_defined
      sensors.fire(:bin_entry) 
    end
    
    def test_on_raises_a_no_such_sensor_exception
      assert_raises NoSuchSensorException do 
        sensors.on(:bin_entry) {}
      end
    end
    
  end

end
