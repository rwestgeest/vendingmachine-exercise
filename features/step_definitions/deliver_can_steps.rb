require 'command_processor'
require 'test/unit/assertions'
include Test::Unit::Assertions
Given /^a machine$/ do
  @machine = CommandProcessor.client
end

When /^drawer (\d+) drops a can$/ do |arg1|
  @machine.clear_bin_events
  @machine.drop_can_from_drawer(arg1.to_i)
end

Then /^it is received by the bin$/ do
  sleep(3)
  assert @machine.bin_has_received_something
end

