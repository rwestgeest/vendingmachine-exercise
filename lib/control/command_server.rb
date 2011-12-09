require 'drb'
require 'devices'
require 'device_wrappers'
module Control

  class CommandServer
    URI = "druby://localhost:14567"

    include VMLog
    def self.start
      DRb.start_service(URI, self.new)
    end

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
