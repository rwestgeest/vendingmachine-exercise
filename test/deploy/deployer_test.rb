require File.join(File.dirname(__FILE__),'..','test_helper')
require 'deploy'
module Deploy
  class DeployerDeployTest < Test::Unit::TestCase
    attr_reader :deployer
    def setup
      @deployer = Deployer.new()
    end

    def test_loads_the_control_file
      deployer.deploy a_file("control.rb").with("@@file_ran = 'file was loaded'").file_path
      assert_equal "file was loaded", @@file_ran
    end

    def a_file(filename)
      FileBuilder.new(filename)
    end

    class FileBuilder
      def initialize(filename)
        @filename = filename
      end
      def with(content)
        File.open(@filename, "w+") { |f| f.puts content }
        return self
      end
      def file_path
        File.expand_path(@filename)
      end
    end
  end
end
