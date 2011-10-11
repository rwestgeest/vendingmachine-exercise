require 'rubygems'
#Gem::manage_gems
require 'rake/gempackagetask'
require 'rake/testtask'
require 'cucumber/rake/task'
require File.join(File.dirname(__FILE__),'config/vending_machine_version')


desc 'Running all unit tests'
task :default => :test

desc "run feature tests"
Cucumber::Rake::Task.new(:features => :deploy) do |t|
  t.cucumber_opts = "--format pretty"
end

desc "Running all unit tests"
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

desc 'deploy code to machine'
task :deploy => :test do
  deploy_code
  sleep(1)
end

PACKAGE = 'controlcode.pkg'
def deploy_code
  rm PACKAGE if File.exists? PACKAGE
  sh "zip -r #{PACKAGE} lib"
  sh "vmdeploy #{PACKAGE}"
end
