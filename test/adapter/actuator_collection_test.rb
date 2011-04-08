require File.join(File.dirname(__FILE__),'..','test_helper')
require 'hardware_adapter'

module Adapter
  class ActuatorCollectionTest < Test::Unit::TestCase
    attr_reader :actuator_collection, :actuator_called, :other_actuator_called
    def setup
      @actuator_collection = ActuatorCollection.new(SynchronousFirer)
      @actuator_called = false
      @other_actuator_called = false
      actuator_collection.create_actuator_for('some_actuator') do
        @actuator_called = true
      end
      actuator_collection.create_actuator_for(:some_other_actuator) do
        @other_actuator_called = true
      end
    end
    
    def test_list_lists_actuators 
      assert_equal [:some_actuator, :some_other_actuator], actuator_collection.list
    end
    
    def test_actuators_not_called_if_not_fired
      assert_equal false, actuator_called, "this actuator should not be called yet"
      assert_equal false, other_actuator_called, "this actuator should not be called yet"
    end
    
    def test_calls_block_given_for_any_actuator
      actuator_collection.fire(:some_actuator)
      actuator_collection.fire(:some_other_actuator)
      
      assert actuator_called, "actuator should be called on fire"
      assert other_actuator_called, "actuator should be called on fire"
    end
    
    def test_actuator_block_can_accept_parameters
      int_val = -1
      string_val = ""
      actuator_collection.create_actuator_for(:parametarized_actuator) do |param1, param2|
        int_val = param1
        string_val = param2
      end
      actuator_collection.fire(:parametarized_actuator, 34, "gijs")
      
      assert_equal 34, int_val
      assert_equal "gijs", string_val
    end

    def test_actuator_block_may_skip_parameters
      int_val = -1
      string_val = ""
      actuator_collection.create_actuator_for(:parametarized_actuator) do |param1, param2|
        int_val = param1
        string_val = param2
      end
      actuator_collection.fire(:parametarized_actuator, 34, "gijs", "truus")
      
      assert_equal 34, int_val
      assert_equal "gijs", string_val
    end
    
    def test_raises_exception_on_firing_unknown_actuator
      assert_raises NoSuchActuatorException do
        actuator_collection.fire(:unknown_actuator)
      end
    end
    
    def test_raises_exception_on_no_block_given
      assert_raises NoActuatorBlockGiven do
        actuator_collection.create_actuator_for(:actuator_no_block)
      end
    end
    
    def test_raises_exception_on_duplicate_actuator
      assert_raises DuplicateActuatorException do
        actuator_collection.create_actuator_for(:some_actuator) {}
      end
    end
  end
  
  class AsynchronousFirerTest < Test::Unit::TestCase
    def test_fires_on_other_thread
      fired = false
      firer = AsynchronousFirer.new do
        sleep(0.1)
        fired = true 
      end
      t = firer.fire
      assert_equal false, fired, "should not be fired"
      t.join
      assert fired, "should be fired"
    end
    
    def test_fires_on_other_thread_with_parameters
      fired = ''
      firer = AsynchronousFirer.new do |value|
        sleep(0.1)
        fired = value
      end
      t = firer.fire('passed string value')
      assert_equal '', fired, "should not be fired"
      t.join
      assert_equal 'passed string value', fired, "should be fired"
    end
  end
end
