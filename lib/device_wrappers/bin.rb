class PhyscalBin
  def initialize
    @events_received = 0
    Devices.on_bin_entry do
      @events_received += 1
    end
  end
  def empty?
    @events_received == 0
  end
end

