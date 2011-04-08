require 'rubygems'
#Gem::manage_gems
require 'rake/gempackagetask'
require 'rake/testtask'
require 'cucumber/rake/task'
require File.join(File.dirname(__FILE__),'config/vending_machine_version')


desc 'Running all unit tests'
task :default => :features

desc "run feature tests"
Cucumber::Rake::Task.new(:features => :test) do |t|
  t.cucumber_opts = "--format pretty"
end  

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
 

 
