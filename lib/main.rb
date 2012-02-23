require "vmlog"
require 'devices'
require 'control/command_server'
require 'control/vending_machine'

module Control
  extend VMLog
  
  def self.main
    # here, you should load your vending machine control software
    CommandServer.start

  end
end

