require 'hardware_adapter'
module Hardware
  class Simulator
   
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
      assemble_hardware_component :bin, bin
      assemble_hardware_component :display, Hardware::Display.new(actuators) 
      assemble_hardware_component :cash_register, Hardware::CashRegister.new(bin, sensors, actuators) 
      assemble_hardware_components :drawer, drawers
      assemble_hardware_components :button, buttons
    end

    private 
    attr_reader :actuators, :sensors
    def component_name(basename, sequence_number)
      "#{basename}_#{sequence_number}".to_sym
    end

    def drawers
        @drawers ||= [ Hardware::Drawer.new(bin,sensors,actuators, 0), 
          Hardware::Drawer.new(bin,sensors,actuators, 1),
          Hardware::Drawer.new(bin,sensors,actuators, 2),
          Hardware::Drawer.new(bin,sensors,actuators, 3)]
    end

    def buttons
      @buttons ||= [ Hardware::Button.new(sensors, 0), 
                    Hardware::Button.new(sensors, 1), 
                    Hardware::Button.new(sensors, 2), 
                    Hardware::Button.new(sensors, 3)]
    end

    def bin
      @bin ||= Hardware::Bin.new(sensors)
    end
  end
end
