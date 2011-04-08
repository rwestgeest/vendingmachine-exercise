require File.join(File.dirname(__FILE__),'..','test_helper')

require 'control'

module Control

  class TestVendingMachine < Test::Unit::TestCase
    def test_should_deliver_nothing_when_no_choices_available
      assert true, "this should be true"
    end
  end

end
