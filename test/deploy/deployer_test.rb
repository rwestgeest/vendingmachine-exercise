require File.join(File.dirname(__FILE__),'..','test_helper')
require 'deploy'
require 'tmpdir'

module Deploy

  class DeployerTest < Test::Unit::TestCase
    attr_reader :deployer
    def setup
      @deployer = Deploy
    end

    def test_loads_a_deployed_file
      deployer.deploy an_archive('controlcode.pkg') {  
        a_file("control.rb").with("class LoadedClass; end")
      }.file_path
      assert defined?(ControlCode::LoadedClass), "ControlCode::LoadedClass should be defined"
    end

    def test_reloads_a_deployed_file
      deployer.deploy an_archive('controlcode.pkg') {
        a_file("control.rb").with("class PreviousLyLoadedClass; end")
      }.file_path
      deployer.deploy an_archive('controlcode.pkg') {
        a_file("control.rb").with("class LoadedClass; end")
      }.file_path

      assert !defined?(ControlCode::PreviousLyLoadedClass), "ControlCode::PreviousLyLoadedClass should not be defined"
      assert defined?(ControlCode::LoadedClass), "ControlCode::LoadedClass should be defined"
    end

    def test_loads_a_deployed_file_required_by_another_file
      deployer.deploy an_archive('controlcode.pkg') {  
        a_file("loaded_class.rb").with("class LoadedClass; end")
        a_file("control.rb").with(%Q{
                  require 'loaded_class'
        })
      }.file_path
      assert defined?(ControlCode::LoadedClass), "ControlCode::LoadedClass should be defined"
    end

    def test_reloads_a_deployed_file_required_by_another_file
      deployer.deploy an_archive('controlcode.pkg') {  
        a_file("loaded_class.rb").with("class PreviousLyLoadedClass; end")
        a_file("control.rb").with("require 'loaded_class'")
      }.file_path
      deployer.deploy an_archive('controlcode.pkg') {  
        a_file("loaded_class.rb").with("class LoadedClass; end")
        a_file("control.rb").with("require 'loaded_class'")
      }.file_path
      assert !defined?(ControlCode::PreviousLyLoadedClass), "ControlCode::PreviousLyLoadedClass should not be defined"
      assert defined?(ControlCode::LoadedClass), "ControlCode::LoadedClass should be defined"
    end


    def an_archive(filename, &block)
      archive = ArchiveBuilder.new(filename)
      archive.in_work_dir(&block) if block_given?
      return archive.build
    end

    require 'fileutils'
    class ArchiveBuilder
      include FileUtils
      def initialize(filename, work_dir = Dir.tmpdir)
        @filename = filename
        @work_dir = File.join(work_dir, 'archive_builder')
        mk_work_dir
      end
      def a_file(filename)
        FileBuilder.new(filename)
      end

      def in_work_dir(&block)
        cd(@work_dir) do
          instance_eval(&block)
        end
      end

      def build
        cd(@work_dir) do
          system "zip -r #{@filename} *"
        end
        return self
      end

      def file_path
        File.expand_path(File.join(@work_dir, @filename))
      end
      private
      def mk_work_dir
        rm_r(@work_dir) if File.exists?(@work_dir)
        mkdir(@work_dir) 
      end
    end

    class FileBuilder
      attr_reader :filename
      def initialize(filename)
        @filename = filename
      end

      def with(content)
        File.open(filename, "w+") { |f| f.puts content }
        return self
      end
    end
  end
end

