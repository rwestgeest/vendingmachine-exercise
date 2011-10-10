require 'devices'
require 'device_wrappers'
module Control

  class RemoteCommands
    include VMLog
    def test
      log "works"
    end

    def clear_bin_events
      @bin = PhyscalBin.new
    end

    def drop_can_from_drawer(drawer)
      PhysicalDrawer.new(drawer).drop_can
    end

    def bin_has_received_something
      !@bin.empty?
    end
  end
end
