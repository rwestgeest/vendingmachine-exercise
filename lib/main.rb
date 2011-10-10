require "vmlog"
require 'devices'
require 'command_processor'
require 'control/remote_commands'
require 'control/vending_machine'

module Control
  extend VMLog
  
  def self.main
    # here, you should load your vending machine control software
    CommandProcessor.run_server(RemoteCommands.new)

    # as an example of using the actuators and sensors (see doc/actuators_and_sensors)
    Devices.display_show(0, 'Choose')
    Devices.display_show(1, 'Please...')

    Devices.on_button_pressed(0) do
      log "cola pressed"

      Devices.display_show(0, 'Cola')
    end
  end
end

