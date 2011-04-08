module Hardware
  class Display < Component
    
    def initialize(actuator_collection) 
      super(nil, actuator_collection)
      @lines = ['','']
    end

    def line_one
      @lines[0]
    end
    
    def line_two
      @lines[1]
    end

    def show(line, message)
      return unless line.is_a?(Fixnum) && line >= 0
      @lines[line] = message[0,16]
      changed
    end

    def configure
      create_actuator_for(:display_show) do |line, message|
        show(line, message)
      end
    end    
  end
end
