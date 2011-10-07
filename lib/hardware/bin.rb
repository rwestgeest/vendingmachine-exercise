module Hardware
  
  class Bin < Component
    attr_reader :contents
    def initialize(sensor_collection)
      super(sensor_collection, nil)
      @contents = [] 
    end
    
    def receive(object)
      contents << object
      changed
      fire(:bin_entry)
    end
    
    def fetch_all
      contents.clear
      changed
      fire(:bin_fetch_all)
    end
    
    def configure
      create_sensor_for(:bin_entry)
      create_sensor_for(:bin_fetch_all)
    end
    

  end
end
