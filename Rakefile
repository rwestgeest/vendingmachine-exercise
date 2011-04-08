require 'rubygems'
require 'rake/testtask'
require File.join(File.dirname(__FILE__),'config/vending_machine_version')


desc 'Running all unit tests'
task :default => :test

Rake::TestTask.new(:test) do |t| 
  t.test_files = FileList['test/**/*test.rb', 'test/*test.rb']
end
 
desc 'Measures test coverage'
task :coverage do
   rm_f "coverage"
   rm_f "coverage.data"
   rcov = "rcov --aggregate coverage.data"
   system("#{rcov} --html test/*test.rb")
end
 

 
