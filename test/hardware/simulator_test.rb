require File.join(File.dirname(__FILE__),'..','test_helper')
require 'mocha'
require 'hardware'

module Hardware 
  class SimulatorAssembleABinTest < Test::Unit::TestCase
    def test_attaches_a_sensor_to_receiving_an_item
      sensors = Adapter::SensorCollection.new
      simulator = Simulator.new
      bin = Bin.new(sensors)
      simulator.assemble_hardware_component(:bin, bin)
      sensor_called = false
      sensors.on(:bin_entry) do
        sensor_called = true
      end 
      bin.receive("some_object")
      assert sensor_called, "bin_entry sensor should be fired"
    end
  end
  
  class SimulatorAssembleHardwareComponents < Test::Unit::TestCase
    attr_reader :sensors, :simulator, :component
    def setup
      @sensors = Adapter::SensorCollection.new
      @simulator = Simulator.new
      @component = mock("hardware_component")
    end
      
    def test_configuring_a_hardware_component_configures_the_component
      component.expects(:configure).with().once
      simulator.assemble_hardware_component(:bin, component)
    end

    def test_configuring_a_list_of_similar_hardware_components_configures_them_all
      component.expects(:configure).with().twice
      simulator.assemble_hardware_components(:drawer, [component, component])
    end

    def test_configured_hardware_component_is_available_by_name
      bin = stub('bin', :configure)
      simulator.assemble_hardware_component(:bin, bin)
      assert_same bin, simulator.component(:bin)
    end

    def test_configured_hardware_components_are_available_by_name
      drawer0 = stub('drawer0', :configure)
      drawer1 = stub('drawer1', :configure)

      simulator.assemble_hardware_components(:drawer, [drawer0, drawer1])
      
      assert_same drawer0, simulator.component(:drawer_0)
      assert_same drawer1, simulator.component(:drawer_1)
    end

    def test_monitor_changes_delegates_to_the_appropriate_hardware_component
      component.stubs(:configure)
      simulator.assemble_hardware_component(:my_comp, component)

      component.expects(:monitor_changes).yields()
      block_given = 'block not given'
      simulator.monitor_changes(:my_comp) do
        block_given = 'block_given'
      end
      
      assert_equal 'block_given', block_given
    end
  end

  class SimulatorAssembleHardware < Test::Unit::TestCase 
    attr_reader :actuators, :sensors, :simulator
    def setup
      @actuators = Adapter::ActuatorCollection.new
      @sensors = Adapter::SensorCollection.new
      @simulator = Simulator.new(actuators, sensors) 
    end

    def test_assembles_one_bin 
      simulator.assemble_hardware
      assert_equal(Bin, simulator.bin.class)
      assert sensors.list.include?(:bin_entry)
      assert sensors.list.include?(:bin_fetch_all)
    end

    def test_assembles_one_display 
      simulator.assemble_hardware
      assert_equal(Display, simulator.display.class)
      assert actuators.list.include?(:display_show)
    end

    def test_assembles_4_drawers
      simulator.assemble_hardware
      assert_equal(Drawer, simulator.drawer(0).class)
      assert_equal(Drawer, simulator.drawer(1).class)
      assert_equal(Drawer, simulator.drawer(2).class)
      assert_equal(Drawer, simulator.drawer(3).class)
      assert actuators.list.include?(:drawer_drop_can_0)
      assert actuators.list.include?(:drawer_drop_can_1)
      assert actuators.list.include?(:drawer_drop_can_2)
      assert actuators.list.include?(:drawer_drop_can_3)
      assert sensors.list.include?(:drawer_drop_can_0)
      assert sensors.list.include?(:drawer_drop_can_1)
      assert sensors.list.include?(:drawer_drop_can_2)
      assert sensors.list.include?(:drawer_drop_can_3)
      assert sensors.list.include?(:drawer_fill_can_0)
      assert sensors.list.include?(:drawer_fill_can_1)
      assert sensors.list.include?(:drawer_fill_can_2)
      assert sensors.list.include?(:drawer_fill_can_3)
    end
    def test_assembles_4_buttons
      simulator.assemble_hardware
      assert_equal(Button, simulator.button(0).class)
      assert_equal(Button, simulator.button(1).class)
      assert_equal(Button, simulator.button(2).class)
      assert_equal(Button, simulator.button(3).class)
      assert sensors.list.include?(:button_press_0)
      assert sensors.list.include?(:button_press_1)
      assert sensors.list.include?(:button_press_2)
      assert sensors.list.include?(:button_press_3)
    end

    def test_assembles_cash_register
      simulator.assemble_hardware
      assert_equal(CashRegister, simulator.component(:cash_register).class)
      assert actuators.list.include?(:cash_drop_100)
      assert actuators.list.include?(:cash_drop_200)
      assert actuators.list.include?(:cash_drop_50)
      assert sensors.list.include?(:cash_fill_100)
      assert sensors.list.include?(:cash_fill_200)
      assert sensors.list.include?(:cash_fill_50)
      assert sensors.list.include?(:cash_insert_100)
      assert sensors.list.include?(:cash_insert_200)
      assert sensors.list.include?(:cash_insert_50)
    end
  end

  class SimulatorReset < Test::Unit::TestCase
    attr_reader :actuators, :sensors, :simulator
    def setup
      @actuators = Adapter::ActuatorCollection.new
      @sensors = Adapter::SensorCollection.new
      @simulator = Simulator.new(actuators, sensors) 
      simulator.assemble_hardware
    end

    def test_empties_drawers
      simulator.drawer(0).fill(Hardware::Can.cola, 2, 0)
      simulator.reset
      assert simulator.drawer(0).empty?
    end

    def test_empties_cash_register
      simulator.cash_register.fill(Hardware::Coin.one_euro, 2, 0)
      simulator.reset
      assert simulator.cash_register.empty?
    end

    def test_removes_sensor_listeners
      bin_entry_called = "was not called"
      sensors.on(:bin_entry) { bin_entry_called = "was called" }
      simulator.reset
      sensors.fire(:bin_entry) 

      assert_equal "was not called",  bin_entry_called
    end

    def test_fires_start_boot_block
      boot_block = "was not called"
      simulator.on_boot { boot_block = "was called" }
      simulator.reset
      assert_equal "was called", boot_block
    end
  end

  class SimulatorBoot < Test::Unit::TestCase
    attr_reader :simulator
    def setup
      @simulator = Simulator.new(Adapter::ActuatorCollection.null, Adapter::SensorCollection.null)
      simulator.assemble_hardware
    end

    def test_fires_start_boot_block
      boot_block = "was not called"
      simulator.on_boot { boot_block = "was called" }
      simulator.boot
      assert_equal "was called", boot_block
    end
  end

end
