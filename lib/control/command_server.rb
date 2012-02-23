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

  end
end
