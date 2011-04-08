module Control
  def self.load
    # here, you should load your vending machine control software

    # as an example of using the actuators and sensors (see doc/actuators_and_sensors)
    Adapter.actuators.fire(:display_show, 0, 'Maak uw keuze>')
    Adapter.actuators.fire(:display_show, 1, '..toe nou...')
    Adapter.sensors.on(:button_press_0) do
      puts "cola pressed"
    end

    # loading the control software could look like:
    VendingMachine.new # buttons, drawers, cashregister and bin
  end
end
