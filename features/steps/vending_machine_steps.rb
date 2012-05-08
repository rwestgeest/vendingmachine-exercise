
Given /^a machine with cola and sprite$/ do
  @bin = Bin.new
  @vendingmachine = VendingMachine.new(@bin)
end

When /^I choose cola$/ do
  @vendingmachine.choose(Choice.cola)
end

Then /^A can of cola is delivered$/ do
  @bin.include?(Can.cola)
end

