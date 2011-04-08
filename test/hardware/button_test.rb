require File.join(File.dirname(__FILE__),'..','test_helper')
require 'mocha'
require 'hardware'

module Hardware
  class ButtonTest < Test::Unit::TestCase
    attr_reader :sensor_collection, :button
    def setup
      @sensor_collection = mock('sensor_collection')
      @button = Button.new(sensor_collection, 1)
    end
    
    def test_press_fires_sensor
      sensor_collection.expects(:fire).with(:button_press_1)
      button.press
    end
    
    def test_configure_configures_sensor_for_button_press
      sensor_collection.expects(:create_sensor_for).with(:button_press_1)
      button.configure
    end
  end
end
