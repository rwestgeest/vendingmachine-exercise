require File.join(File.dirname(__FILE__),'..','test_helper')
require 'hardware'

module Hardware
  class MyComponent < Component
    def changed # published protected method
      super
    end 
  end
  
  class ComponentMonitorChangesTest < Test::Unit::TestCase
    attr_reader :component, :changed_block_called
    def setup
      @component = MyComponent.new(nil,nil)
      @changed_block_called = 'changed_block_not_called'
      component.monitor_changes do
        @changed_block_called = 'changed_block_called'
      end
    end

    def test_changes_block_initially_not_called
      assert_equal 'changed_block_not_called', changed_block_called
    end
    
    def test_changes_block_initially_called_when_changed
      component.changed
      assert_equal 'changed_block_called', changed_block_called
    end

    def test_changed_ignored_when_block_not_registered
      @component = MyComponent.new(nil,nil)
      component.changed
      assert_equal 'changed_block_not_called', changed_block_called
    end

  end
end
