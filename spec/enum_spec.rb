require File.join(File.dirname(__FILE__),'spec_helper')
require 'enum'

describe Enum do
  class MyEnum < Enum
    values :first, :second
  end

  describe "value" do
    it "is accessible with class method" do
      expect {
        MyEnum.first
      }.to_not raise_exception
    end

    it "raises an exception when not defined" do
      expect { 
        MyEnum.blah
      }.to raise_exception(RuntimeError)
    end

    it "inspection returns a readable string" do
      MyEnum.first.inspect.should == 'MyEnum.first'
    end

    describe "sameness" do
      it "is true when values are the same" do
        MyEnum.first.should === MyEnum.first
      end
      it "is false on comparing different values" do
        MyEnum.first.should_not == MyEnum.second
      end
    end
  end
end
