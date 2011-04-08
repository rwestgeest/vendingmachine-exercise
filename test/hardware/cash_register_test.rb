require File.join(File.dirname(__FILE__),'..','test_helper')
require 'mocha'
require 'hardware'
require 'hardware_adapter'

module Hardware
  RIGHT_AWAY = 0
  class CashRegisterDroppingCoinsInBin < Test::Unit::TestCase
    attr_reader :register, :bin
    def setup
      @bin = mock('bin')
      @register = CashRegister.new(bin, Adapter::SensorCollection.null, nil)
      register.fill(Coin.two_euro, 1, RIGHT_AWAY)
    end

    def test_drops_coin_in_bin
      bin.expects(:receive).with(Coin.two_euro)
      register.drop_coin(Coin.two_euro, RIGHT_AWAY)
    end

    def test_drops_nohting_when_empty
      bin.expects(:receive).with(Coin.two_euro).never
      register.drop_coin(Coin.one_euro, RIGHT_AWAY)
    end
    
    def test_drops_eventually_empties_the_coin_stock
      bin.expects(:receive).with(Coin.two_euro).once
      register.drop_coin(Coin.two_euro, RIGHT_AWAY)
      register.drop_coin(Coin.two_euro, RIGHT_AWAY)
    end
    
    def test_filling_coins_adds_to_stock
      register.fill(Coin.two_euro, 1, 0)
      bin.expects(:receive).with(Coin.two_euro).twice
      register.drop_coin(Coin.two_euro, RIGHT_AWAY)
      register.drop_coin(Coin.two_euro, RIGHT_AWAY)
      register.drop_coin(Coin.two_euro, RIGHT_AWAY)
    end

    def test_insert_coin_adds_it_to_stock
      register.insert_coin(Coin.two_euro)
      bin.expects(:receive).with(Coin.two_euro).twice
      register.drop_coin(Coin.two_euro, RIGHT_AWAY)
      register.drop_coin(Coin.two_euro, RIGHT_AWAY)
      register.drop_coin(Coin.two_euro, RIGHT_AWAY)
    end
    
  end
  
  class CashRegisterSensorFiringTest < Test::Unit::TestCase
    attr_reader :register, :bin, :sensor_collection

    def setup 
      @bin = stub('bin', :receive)
      @sensor_collection = mock('sensor_collection')
      @register = CashRegister.new(bin, sensor_collection, nil)
    end
    
    def test_insert_two_euros_fires_cash_insert_200
      sensor_collection.expects(:fire).with(:cash_insert_200)
      register.insert_coin(Coin.two_euro)
    end
    
    def test_insert_one_euro_fires_cash_insert_100
      sensor_collection.expects(:fire).with(:cash_insert_100)
      register.insert_coin(Coin.one_euro)
    end
    
    def test_insert_fifty_cents_fires_cash_insert_50
      sensor_collection.expects(:fire).with(:cash_insert_50)
      register.insert_coin(Coin.fifty_cents)
    end
    
    def test_filling_two_euros_fires_cash_fills_200
      sensor_collection.expects(:fire).with(:cash_fill_200).twice
      register.fill(Coin.two_euro, 2, RIGHT_AWAY)
    end
    
    def test_filling_one_euro_fires_cash_fills_100
      sensor_collection.expects(:fire).with(:cash_fill_100).once
      register.fill(Coin.one_euro, 1, RIGHT_AWAY)
    end
    
    def test_filling_fifty_cents_fires_cash_fills_50
      sensor_collection.expects(:fire).with(:cash_fill_50).twice
      register.fill(Coin.fifty_cents, 2, RIGHT_AWAY)
    end
  end  

  class CashRegisterConfigureTest < Test::Unit::TestCase
    attr_reader :sensor_collection, :actuator_collection, :register
    def setup
      @sensor_collection = mock('sensor_collection')
      @actuator_collection = mock('actuator_collection')
      @register = CashRegister.new(nil, sensor_collection, actuator_collection)
    end
    
    def test_configures_sensors_for_coins_insertions_and_actuators_for_coin_drops
      sensor_collection.expects(:create_sensor_for).with(:cash_insert_200)
      sensor_collection.expects(:create_sensor_for).with(:cash_insert_100)
      sensor_collection.expects(:create_sensor_for).with(:cash_insert_50)
      sensor_collection.expects(:create_sensor_for).with(:cash_fill_200)
      sensor_collection.expects(:create_sensor_for).with(:cash_fill_100)
      sensor_collection.expects(:create_sensor_for).with(:cash_fill_50)
      actuator_collection.expects(:create_actuator_for).with(:cash_drop_200)
      actuator_collection.expects(:create_actuator_for).with(:cash_drop_100)
      actuator_collection.expects(:create_actuator_for).with(:cash_drop_50)
      
      register.configure()
    end
  end
  

  class MyCashRegister < CashRegister
    def drop_coin(coin)
      @coin = coin
    end
    def coin_dropped?(coin)
      @coin == coin
    end
  end

  class CashRegisterRespondingToActuatorsTest < Test::Unit::TestCase
    attr_reader :sensor_collection, :actuator_collection, :register
    def setup
      @sensor_collection = mock('sensor_collection')
      @actuator_collection = mock('actuator_collection')
      @register = MyCashRegister.new(nil, sensor_collection, actuator_collection)
      sensor_collection.stubs(:create_sensor_for)
      actuator_collection.stubs(:create_actuator_for)
    end
    
    def test_actuating_drop_200_drops_two_euro_coin_in_bin
      actuator_collection.stubs(:create_actuator_for).with(:cash_drop_200).yields
      
      register.configure()
      
      assert register.coin_dropped?(Coin.two_euro), "two euro should be dropped"
    end
    
    def test_actuating_drop_100_drops_one_euro_coin_in_bin
      actuator_collection.stubs(:create_actuator_for).with(:cash_drop_100).yields
      
      register.configure()
      
      assert register.coin_dropped?(Coin.one_euro), "one euro should be dropped"
    end
    
    def test_actuating_drop_100_drops_one_euro_coin_in_bin
      actuator_collection.stubs(:create_actuator_for).with(:cash_drop_50).yields
      
      register.configure()
      
      assert register.coin_dropped?(Coin.fifty_cents), "one euro should be dropped"
    end
  end
end
