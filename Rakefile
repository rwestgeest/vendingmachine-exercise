require 'rubygems'
require 'rspec/core/rake_task'
require File.join(File.dirname(__FILE__),'config/vending_machine_version')


desc 'Running all unit tests'
task :default => :rspec

RSpec::Core::RakeTask.new(:rspec)
 
desc 'Measures test coverage'
task :coverage do
   rm_f "coverage"
   rm_f "coverage.data"
   rcov = "rcov --aggregate coverage.data"
   system("#{rcov} --html test/*test.rb")
end
 

 
