require File.join(File.dirname(__FILE__),'..','test_helper')

require 'control'

module Control
  
  class TestVendingMachine < Test::Unit::TestCase
    attr_reader :machine
    
    def setup
      @machine = VendingMachine.new
      machine.add_choice(Choice.fanta, Can.fanta, 0)
      machine.add_choice(Choice.cola, Can.cola, 0)
      machine.add_choice(Choice.sprite, Can.sprite, 2)
    end
    
    def test_choiceless_machine_delivers_nothing
      machine = VendingMachine.new
      assert_equal(Can.nothing, machine.deliver(Choice.cola))
    end

    def test_delivers_can_of_choice_if_choice_available
      assert_equal(Can.cola, machine.deliver(Choice.cola))
      assert_equal(Can.fanta, machine.deliver(Choice.fanta))
    end

    def test_delivers_nothing_when_not_paid
      assert_equal(Can.nothing, machine.deliver(Choice.sprite))
    end
    
    def test_delivers_can_of_choice_when_paid_enough
      machine.insert(2)
      assert_equal(Can.sprite, machine.deliver(Choice.sprite))
    end
    
  end
  
 
end
