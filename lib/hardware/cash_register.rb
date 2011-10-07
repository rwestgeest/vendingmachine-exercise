require 'enum'
module Hardware
  class Coin < Enum
    values :two_euro, :one_euro, :fifty_cents
    def to_s
      "#{@type} coin"
    end
  end
  
  class CashRegister < Component
    def initialize(bin, sensor_collection, actuator_collection)
      super(sensor_collection, actuator_collection)
      @bin = bin
      @stocks = {}
      @stocks.default = 0
    end
    
    def drop_coin(coin, delay = 1)
      if @stocks[coin] > 0
        sleep(delay)
        @bin.receive(coin) 
        @stocks[coin] -= 1
      end
    end

    def insert_coin(coin_type)
      @stocks[coin_type] += 1
      @sensor_collection.fire(insert_event_for(coin_type))
    end
    
    def insert_event_for(coin_type)
      {Coin.two_euro => :cash_insert_200, 
       Coin.one_euro => :cash_insert_100, 
       Coin.fifty_cents => :cash_insert_50 }[coin_type]
    end
    private :insert_event_for
    
    def fill(coin_type, amount, delay = 1)
      amount.times do 
        sleep(delay)
        @stocks[coin_type] += 1
        @sensor_collection.fire(fill_event_for(coin_type))
      end
    end

    def fill_event_for(coin_type)
      {Coin.two_euro => :cash_fill_200, 
       Coin.one_euro => :cash_fill_100, 
       Coin.fifty_cents => :cash_fill_50 }[coin_type]
    end
    private :insert_event_for

    
    def configure
      create_sensor_for(:cash_insert_200)
      create_sensor_for(:cash_insert_100)
      create_sensor_for(:cash_insert_50)
      create_sensor_for(:cash_fill_200)
      create_sensor_for(:cash_fill_100)
      create_sensor_for(:cash_fill_50)
      create_actuator_for(:cash_drop_200) do
        drop_coin(Coin.two_euro) 
      end
      create_actuator_for(:cash_drop_100) do
        drop_coin(Coin.one_euro) 
      end
      create_actuator_for(:cash_drop_50) do
        drop_coin(Coin.fifty_cents) 
      end
    end

    def empty?
      @stocks.empty?
    end

    def reset
      @stocks.clear
    end
  end
end
