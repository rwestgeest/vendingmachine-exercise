require File.join(File.dirname(__FILE__),'..','test_helper')
require 'mocha'
require 'hardware'
require 'hardware_adapter'

module Hardware 
  class DisplayTest < Test::Unit::TestCase
    attr_reader :display
    
    def setup
      @display = Display.new(Adapter::ActuatorCollection.null)
    end
    
    def test_can_display_text_on_first_line
      display.show(0, "line 1")      
      assert_equal "line 1", display.line_one
      assert_equal "", display.line_two
    end
    
    def test_can_display_text_on_second_line
      display.show(1, "line 2")      
      assert_equal "", display.line_one
      assert_equal "line 2", display.line_two
    end
    
    def test_displaying_on_higher_line_is_ignored
      display.show(3, "blah")      
      assert_equal "", display.line_one
      assert_equal "", display.line_two
    end

    def test_displaying_on_negative_line_is_ignored
      display.show(-1, "blah")      
      assert_equal "", display.line_one
      assert_equal "", display.line_two
    end

    def test_displaying_with_string_as_index_is_ignored
      display.show("0", "blah")      
      assert_equal "", display.line_one
      assert_equal "", display.line_two
    end

    def test_line_will_be_limited_to_16
      display.show(0, "much longer than sixteen chars")      
      assert_equal "much longer than", display.line_one 
      display.show(1, "much longer than sixteen chars")      
      assert_equal "much longer than", display.line_two 
    end


    def test_display_updates_ui_when_show_is_called
      ui_contains = 'nothing'
      display.monitor_changes do
        ui_contains = [display.line_one, display.line_two].join('-')
      end
      display.show(1, 'blah')
      assert_equal '-blah',  ui_contains
    end
    
    def test_display_updates_ui_when_nothing_shown
      ui_contains = 'nothing'
      display.monitor_changes do
        ui_contains = [display.line_one, display.line_two].join('-')
      end
      display.show(-1, 'blah') # error - nothing shown
      assert_equal 'nothing', ui_contains
    end
  end
  
  class DisplayConfigureTest < Test::Unit::TestCase
    attr_reader :display, :actuator_collection
    
    def setup
      @actuator_collection = mock('actuator_collection')
      @display = Display.new(actuator_collection)
    end
    
    def test_configure_configures_actuator_for_display
      actuator_collection.expects(:create_actuator_for).with(:display_show)
      display.configure   
    end
    
    def test_firing_actuator_will_call_show
      actuator_collection.expects(:create_actuator_for).
        with(:display_show).
        yields(0, 'line one')
      
      display.configure  
      assert_equal "line one", display.line_one
      assert_equal "", display.line_two
    end
  end
end
