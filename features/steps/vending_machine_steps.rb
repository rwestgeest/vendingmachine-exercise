
Given /^a machine with cola and sprite$/ do
  @machine = VendingMachine.new
  @machine.configure(Choice.cola, Can.cola)
  @machine.configure(Choice.sprite, Can.sprite)  
end

When /^I choose cola$/ do
  @delivery = @machine.deliver(Choice.sprite)
end

Then /^A can of cola is delivered$/ do
  assert_equal Can.cola, @delivery
end

