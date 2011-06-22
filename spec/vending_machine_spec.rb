require File.join(File.dirname(__FILE__),'spec_helper')

require 'vending_machine'

describe VendingMachine do
  describe "delivery" do
    let(:vending_machine) { VendingMachine.new }

    before(:each) do
      vending_machine.add_choice(Choice.cola, Can.cola)
      vending_machine.add_choice(Choice.fanta, Can.fanta)
    end

    it "delivers can of choice" do
      vending_machine.deliver(Choice.cola).should == Can.cola
      vending_machine.deliver(Choice.fanta).should == Can.fanta
    end

    it "delivers nothing on illegal choice" do
      vending_machine.deliver('bogus_choice').should == Can.nothing
    end
  end
end
