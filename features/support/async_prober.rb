module AsyncProber
  DefaultTimeOut = 3
  Interval = 0.1
  DefaultMessage = "probe to be true (replace with real message)"

  def probe(message=DefaultMessage, &block)
    within(DefaultTimeOut).probe(message, &block)
  end

  def within(time_out)
    Prober.new(time_out)
  end

  class Prober
    def initialize(time_out)
      @time_out = time_out
    end 

    def probe(message = "probe to be true (replace with real message)", &block) 
      time_elapsed = 0
      while(time_elapsed < @time_out) 
        return true if yield 
        sleep(Interval)
        time_elapsed += Interval
      end
      fail("expected " + message + " but was not")
    end
  end
end

