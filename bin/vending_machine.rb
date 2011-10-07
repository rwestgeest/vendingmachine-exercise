#!/usr/bin/env ruby
$: << File.join(File.dirname(__FILE__),'..','lib')

require 'hardware_adapter'
require 'hardware'
require 'control'
require 'gui'

simulator = Hardware::Simulator.new
simulator.assemble_hardware
Gui::SimulatorGui.new(simulator).show
simulator.on_boot do
  simulator.drawer(0).fill(Hardware::Can.cola, 2, 0)
  simulator.drawer(1).fill(Hardware::Can.fanta, 2, 0)
  simulator.drawer(2).fill(Hardware::Can.sprite, 2, 0)
  simulator.drawer(3).fill(Hardware::Can.sisi, 2, 0)

  simulator.cash_register.fill(Hardware::Coin.two_euro, 3, 0)
  simulator.cash_register.fill(Hardware::Coin.one_euro, 3, 0)
  simulator.cash_register.fill(Hardware::Coin.fifty_cents, 3, 0)
end
simulator.boot
Gtk.main
