require 'hardware_adapter'
module Hardware
  class Simulator
   
    def initialize
      @components = {}
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
    
    private 
    def component_name(basename, sequence_number)
      "#{basename}_#{sequence_number}".to_sym
    end
  end
end
