require "vmlog"
require 'devices'

module Control
  include VMLog

  def self.main
    # here, you should load your vending machine control software

    # as an example of using the actuators and sensors (see doc/actuators_and_sensors)
    Devices.display_show(0, 'Choose')
    Devices.display_show(1, 'Please...')

    Devices.on_button_pressed(0) do
      log "cola pressed"

      Devices.display_show(0, 'Cola')
    end
  end
end

