require 'hardware_adapter'
module Hardware
  class Simulator
    attr_reader :bin, :cash_register, :display 

    def initialize(actuators = Adapter.actuators, sensors = Adapter.sensors)
      @components = {}
      @actuators = actuators
      @sensors = sensors
    end
    
    def component(component_name)
      @components[component_name]
    end
     
    def assemble_hardware_component(component_name, component)
      @components[component_name] = component
      component.configure
    end
    
    def assemble_hardware_components(basename, components)
      components.each_with_index do |component, sequence_number|
        assemble_hardware_component(component_name(basename, sequence_number), component) 
      end
    end
    
    def monitor_changes(component_name, &block)
      component(component_name).monitor_changes(&block)
    end

    def assemble_hardware
      assemble_hardware_component :bin, create_bin
      assemble_hardware_component :display, create_display
      assemble_hardware_component :cash_register, create_cash_register
      assemble_hardware_components :drawer, create_drawers
      assemble_hardware_components :button, create_buttons
    end

    def drawer(no)
      @drawers[no]
    end

    def button(no)
      @buttons[no]
    end

    def reset
      @components.each { |name, component| component.reset }
      sensors.remove_fire_listeners 
      boot
    end

    def boot
      call_boot_block
    end

    def on_boot(&block)
      @boot_block = block
    end


    private 
    attr_reader :actuators, :sensors

    def call_boot_block
      @boot_block.call if @boot_block
    end
    def component_name(basename, sequence_number)
      "#{basename}_#{sequence_number}".to_sym
    end

    def create_display
      @display = Hardware::Display.new(actuators)
    end

    def create_cash_register 
      @cash_register = Hardware::CashRegister.new(bin, sensors, actuators) 
    end

    def create_drawers
      @drawers = [ Hardware::Drawer.new(bin,sensors,actuators, 0), 
                  Hardware::Drawer.new(bin,sensors,actuators, 1),
                  Hardware::Drawer.new(bin,sensors,actuators, 2),
                  Hardware::Drawer.new(bin,sensors,actuators, 3)]
    end

    def create_buttons
      @buttons = [ Hardware::Button.new(sensors, 0), 
                    Hardware::Button.new(sensors, 1), 
                    Hardware::Button.new(sensors, 2), 
                    Hardware::Button.new(sensors, 3)]
    end

    def create_bin
      @bin = Hardware::Bin.new(sensors)
    end
  end
end
