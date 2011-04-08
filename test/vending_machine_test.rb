require File.join(File.dirname(__FILE__),'test_helper')

require 'vending_machine'


class VendingMachineTest < Test::Unit::TestCase
    def test_choiceless_machine_delivers_nothing
      assert_equal 0, 1, "kanniewaarzijn dat 0 1 is"
    end
end
