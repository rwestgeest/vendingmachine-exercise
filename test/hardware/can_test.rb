require File.join(File.dirname(__FILE__),'..','test_helper')
require 'hardware'

module Hardware
  class CanTest < Test::Unit::TestCase
    def test_to_s_shows_can_name
      assert_equal 'can of cola', Can.cola.to_s
      assert_equal 'can of fanta', Can.fanta.to_s
    end
  end
end 
