require File.join(File.dirname(__FILE__),'..','test_helper')
require 'mocha'
require 'hardware'
require 'hardware_adapter'

module Hardware
  class BinTest < Test::Unit::TestCase
    attr_reader :bin, :sensor_collection
    def setup
      @sensor_collection = mock('sensor_collection')
      @bin = Bin.new(sensor_collection)
    end
    
    def test_receive_fills_the_bin_with_the_item
      sensor_collection.expects(:fire).with(:bin_entry)
      bin.receive('some_object')
      assert_equal(['some_object'], bin.contents)
    end
    
    def test_fetch_the_stuff_empties_the_bin
      sensor_collection.stubs(:fire).with(:bin_entry) # firing :bin_entry tested above
      bin.receive('some_object')
      bin.receive('some_object')
      
      sensor_collection.expects(:fire).with(:bin_fetch_all)
      bin.fetch_all
      
      assert_equal([], bin.contents)
    end
    
    def test_configure_configures_the_sensor_in_the_sensor_collection
      sensor_collection.expects(:create_sensor_for).with(:bin_entry)
      sensor_collection.expects(:create_sensor_for).with(:bin_fetch_all)
      bin.configure 
    end
    
    def test_updates_ui_when_receiving_something
      bin = Bin.new(Adapter::SensorCollection.null)
      change_called = false
      bin.monitor_changes do
        change_called = true
      end
      bin.receive('some_object')
      assert change_called, 'change was not called'
    end
    
    def test_updates_ui_when_fetching_all
      bin = Bin.new(Adapter::SensorCollection.null)
      change_called = false
      bin.monitor_changes do
        change_called = true
      end
      bin.fetch_all
      assert change_called, 'change was not called'
    end
  end
end
