require File.join(File.dirname(__FILE__),'..','test_helper')
require 'deploy'
require 'tmpdir'
module Deploy
  class DeployerTest < Test::Unit::TestCase
    attr_reader :deployer
    def setup
      @deployer = Deployer.new()
    end

    def test_loads_a_deployed_file
      deployer.deploy a_file("control.rb").with("class LoadedClass; end").file_path
      assert_equal "constant", defined?(LoadedClass)
    end

    def test_reloads_a_deployed_file
      deployer.deploy a_file("control.rb").with("class PreviousLyLoadedClass; end").file_path
      assert_equal "constant", defined?(PreviousLyLoadedClass)
      deployer.deploy a_file("control.rb").with("class LoadedClass; end").file_path
      assert_nil defined?(PreviousLyLoadedClass)
      assert_equal "constant", defined?(LoadedClass)
    end

    def a_file(filename)
      FileBuilder.new(filename)
    end

    class FileBuilder
      def initialize(filename, work_dir = Dir.tmpdir)
        @filename = filename
        @work_dir = File.join(work_dir, 'file_builder')
      end
      def with(content)
        mk_work_dir
        File.open(file_path, "w+") { |f| f.puts content }
        return self
      end
      def file_path
        File.expand_path(File.join(@work_dir,@filename))
      end
      private
      def mk_work_dir
        Dir.mkdir(@work_dir) unless File.exists?(@work_dir)
      end
    end
  end
end
