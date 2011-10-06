#!/usr/bin/env ruby
$: << File.join(File.dirname(__FILE__),'..','lib')

require 'hardware_adapter'
require 'hardware'
require 'control'
require 'gui'

simulator = Hardware::Simulator.new
simulator.assemble_hardware
Gui::SimulatorGui.new(simulator).show
Control.load if defined?(Control.load)

simulator.component(:drawer_0).fill(Hardware::Can.cola, 2, 0)
simulator.component(:drawer_1).fill(Hardware::Can.fanta, 2, 0)
simulator.component(:drawer_2).fill(Hardware::Can.sprite, 2, 0)
simulator.component(:drawer_3).fill(Hardware::Can.sisi, 2, 0)

simulator.component(:cash_register).fill(Hardware::Coin.two_euro, 3, 0)
simulator.component(:cash_register).fill(Hardware::Coin.one_euro, 3, 0)
simulator.component(:cash_register).fill(Hardware::Coin.fifty_cents, 3, 0)


Gtk.main
