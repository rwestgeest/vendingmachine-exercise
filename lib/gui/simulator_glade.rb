#!/usr/bin/env ruby
#
# This file is gererated by ruby-glade-create-template 1.1.4.
#
require 'libglade2'

class SimulatorguiGlade
  include GetText

  attr :glade
  
  def initialize(path_or_data, root = nil, domain = nil, localedir = nil, flag = GladeXML::FILE)
    bindtextdomain(domain, localedir, nil, "UTF-8")
    @glade = GladeXML.new(path_or_data, root, domain, localedir, flag) {|handler| method(handler)}
    
  end
  
  def on_fetch_button_clicked(widget)
    puts "on_fetch_button_clicked() is not implemented yet."
  end
  def on_two_euro_button_clicked(widget)
    puts "on_two_euro_button_clicked() is not implemented yet."
  end
  def on_fanta_button_clicked(widget)
    puts "on_fanta_button_clicked() is not implemented yet."
  end
  def on_sisi_button_clicked(widget)
    puts "on_sisi_button_clicked() is not implemented yet."
  end
  def on_cola_button_clicked(widget)
    puts "on_cola_button_clicked() is not implemented yet."
  end
  def on_sprite_button_clicked(widget)
    puts "on_sprite_button_clicked() is not implemented yet."
  end
  def on_fifty_cents_button_clicked(widget)
    puts "on_fifty_cents_button_clicked() is not implemented yet."
  end
  def on_exit_button_clicked(widget)
    puts "on_exit_button_clicked() is not implemented yet."
  end
  def on_one_euro_button_clicked(widget)
    puts "on_one_euro_button_clicked() is not implemented yet."
  end
end

# Main program
if __FILE__ == $0
  # Set values as your own application. 
  PROG_PATH = "SimulatorGui.glade"
  PROG_NAME = "YOUR_APPLICATION_NAME"
  SimulatorguiGlade.new(PROG_PATH, nil, PROG_NAME)
  Gtk.main
end
