#!/usr/bin/env ruby
$: << File.join(File.dirname(__FILE__),'..','lib')

require 'hardware_adapter'
require 'hardware'
require 'control'
require 'gui'

simulator = Hardware::Simulator.new

bin = Hardware::Bin.new(Adapter.sensors)

drawers = [ Hardware::Drawer.new(bin,Adapter.sensors,Adapter.actuators, 0), 
            Hardware::Drawer.new(bin,Adapter.sensors,Adapter.actuators, 1),
            Hardware::Drawer.new(bin,Adapter.sensors,Adapter.actuators, 2),
            Hardware::Drawer.new(bin,Adapter.sensors,Adapter.actuators, 3)]

buttons = [ Hardware::Button.new(Adapter.sensors, 0), 
            Hardware::Button.new(Adapter.sensors, 1), 
            Hardware::Button.new(Adapter.sensors, 2), 
            Hardware::Button.new(Adapter.sensors, 3)]

display = Hardware::Display.new(Adapter.actuators) 

cash_register = Hardware::CashRegister.new(bin, Adapter.sensors, Adapter.actuators)

simulator.assemble_hardware_component(:bin, bin)
simulator.assemble_hardware_components(:drawer, drawers)
simulator.assemble_hardware_components(:button, buttons)
simulator.assemble_hardware_component(:display, display)
simulator.assemble_hardware_component(:cash_register, cash_register)

Gui::SimulatorGui.new(simulator).show
Control.load if defined?(Control.load)

drawers[0].fill(Hardware::Can.cola, 2, 0)
drawers[1].fill(Hardware::Can.fanta, 2, 0)
drawers[2].fill(Hardware::Can.sprite, 2, 0)
drawers[3].fill(Hardware::Can.sisi, 2, 0)

cash_register.fill(Hardware::Coin.two_euro, 3, 0)
cash_register.fill(Hardware::Coin.one_euro, 3, 0)
cash_register.fill(Hardware::Coin.fifty_cents, 3, 0)


Gtk.main
