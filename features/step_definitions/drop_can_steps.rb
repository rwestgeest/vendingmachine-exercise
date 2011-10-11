Given /^a machine$/ do
  @machine = CommandProcessor.client
end

When /^drawer (\d+) drops a can$/ do |arg1|
  @machine.clear_bin_events
  @machine.drop_can_from_drawer(arg1.to_i)
end

Then /^it is received by the bin$/ do
  probe("bin should be filled") { @machine.bin_has_received_something }
end

