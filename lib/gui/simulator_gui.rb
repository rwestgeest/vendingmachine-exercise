
PROG_PATH = File.join(File.dirname(__FILE__), "SimulatorGui.glade")

PROG_NAME = "Vending Machine"
module Gui
  class SimulatorGui < SimulatorguiGlade
    def initialize(simulator)
      super(PROG_PATH, nil, PROG_NAME)
      @simulator = simulator
      
      simulator.monitor_changes(:bin) do
        glade['bin_box'].buffer.text = @simulator.component(:bin).contents.join("\n")
      end
      simulator.monitor_changes(:display) do
        glade['display_line_1'].buffer.text = @simulator.component(:display).line_one
        glade['display_line_2'].buffer.text = @simulator.component(:display).line_two
      end
    end
    
    def on_fetch_button_clicked(widget)
      @simulator.component(:bin).fetch_all
    end

    def on_cola_button_clicked(widget)
      @simulator.component(:button_0).press
    end
    
    def on_fanta_button_clicked(widget)
      @simulator.component(:button_1).press
    end
    
    def on_sprite_button_clicked(widget)
      @simulator.component(:button_2).press
    end
    
    def on_sisi_button_clicked(widget)
      @simulator.component(:button_3).press
    end
    
    def on_two_euro_button_clicked(widget)
      @simulator.component(:cash_register).insert_coin(Hardware::Coin.two_euro)
    end
    
    def on_one_euro_button_clicked(widget)
      @simulator.component(:cash_register).insert_coin(Hardware::Coin.one_euro)
    end
    
    def on_fifty_cents_button_clicked(widget)
      @simulator.component(:cash_register).insert_coin(Hardware::Coin.fifty_cents)
    end
    
    def on_exit_button_clicked(widget)
      Gtk.main_quit()
    end

    def show
       glade['window1'].show_all
    end
  end
end
