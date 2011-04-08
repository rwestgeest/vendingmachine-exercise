require File.join(File.dirname(__FILE__),'test_helper')

require 'vending_machine'


class VendingMachineTest < Test::Unit::TestCase
    attr_reader :machine
    def setup
        @machine = VendingMachine.new
    end
    
    def test_choiceless_machine_delivers_nothing
        assert_equal(Can.none, machine.deliver(Choice.cola))
        assert_equal(Can.none, machine.deliver(Choice.fanta))
    end

    def test_delivers_cola_when_choosing_cola
        machine.configure(Choice.cola, Can.cola)
        assert_equal(Can.cola, machine.deliver(Choice.cola))
    end
    
    def test_delivers_nothing_when_making_invalid_choice
        machine.configure(Choice.cola, Can.cola)
        assert_equal(Can.none, machine.deliver(Choice.fanta))
    end
end
