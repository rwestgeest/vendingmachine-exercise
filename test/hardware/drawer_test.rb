require File.expand_path File.join(File.dirname(__FILE__),'..','test_helper')
require 'mocha'
require 'hardware'

module Hardware
  RIGHT_AWAY = 0
  class DrawerDroppingTest < Test::Unit::TestCase
    attr_reader :drawer, :bin

    def setup 
      @bin = mock('bin')
      @drawer = Drawer.new(bin)
      @drawer.fill(Can.cola, 1, RIGHT_AWAY)
    end
    
    def test_drops_item_to_bin
      bin.expects(:receive).with(Can.cola)
      drawer.drop(RIGHT_AWAY)
      bin.expects(:receive).with(Can.fanta)
      Drawer.new(bin).fill(Can.fanta, 1, RIGHT_AWAY).drop(RIGHT_AWAY)
    end
   
    def test_dropping_reduces_the_stock
      bin.stubs(:receive)
      drawer.drop(RIGHT_AWAY)
      assert_equal [], drawer.stock 
    end

    def test_dropping_more_than_you_have_has_no_effect
      bin.expects(:receive).with(Can.cola).once
      drawer.drop(RIGHT_AWAY)
      drawer.drop(RIGHT_AWAY)
    end
    
    def test_filling_adds_a_number_of_cans_in_stock
      drawer.fill(Can.cola, 2, RIGHT_AWAY)
      assert_equal([Can.cola, Can.cola, Can.cola], drawer.stock)
    end
  end
  
  class DrawerSensorTest < Test::Unit::TestCase
    attr_reader :drawer, :bin, :sensor_collection

    def setup 
      @bin = stub('bin', :receive)
      @sensor_collection = mock('sensor_collection')
      @drawer = Drawer.new(bin, sensor_collection)
    end
    
    def test_dropping_a_can_fires_a_sensor_event
      @sensor_collection.stubs(:fire).with(:drawer_fill_can_0)
      @drawer.fill(Can.cola, 1, RIGHT_AWAY)
      @sensor_collection.expects(:fire).with(:drawer_drop_can_0)
      @drawer.drop(RIGHT_AWAY)
    end
    
    def test_filling_fires_fill_can_event_for_each_can
      @sensor_collection.expects(:fire).with(:drawer_fill_can_0).times(3)
      @drawer.fill(Can.cola, 3, RIGHT_AWAY)
    end
  
  end

  class ConfiguringDrawerTest < Test::Unit::TestCase
    attr_reader :drawer, :bin, :sensor_collection, :actuator_collection
    
    def setup
      @sensor_collection = mock('sensor_collection')
      @actuator_collection = mock('mock_collection')
      @bin = mock('bin')
      
      @drawer = Drawer.new(bin, sensor_collection, actuator_collection, 1)
    end
    
    def test_configure_sensors_configures_drop_and_fill_can
      sensor_collection.expects(:create_sensor_for).with(:drawer_drop_can_1)
      sensor_collection.expects(:create_sensor_for).with(:drawer_fill_can_1)
      actuator_collection.expects(:create_actuator_for).with(:drawer_drop_can_1)

      drawer.configure
    end
    
    def test_fired_actuator_drops_can
      sensor_collection.stubs(:create_sensor_for)
      # YIELD is what happens when the actuator is fired
      actuator_collection.expects(:create_actuator_for).with(:drawer_drop_can_1).yields

      def drawer.drop
        @drop_called = true
      end
      def drawer.drop_called
        @drop_called
      end

      drawer.configure
      
      assert drawer.drop_called, "drop should be called as result of yield of actuator"
    end
  end
end
