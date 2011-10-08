
require 'fileutils'
module Deploy
  def self.deploy(file)
    Deployer.new(file).deploy
  end
  class Deployer
    include FileUtils
    DEPLOYED_DIR = File.expand_path("~/.vendingmachine")

    attr_reader :file_path

    def initialize(file_path)
      @file_path = file_path
      $: << DEPLOYED_DIR unless $:.include?(DEPLOYED_DIR)
    end

    def deploy
      rm_r Dir.glob(File.join(DEPLOYED_DIR, '*'))
      cd(DEPLOYED_DIR) do
        system "unzip #{file_path}"
      end

      load_classes
    end

    def load_classes
      Object.send(:remove_const, "ControlCode") if defined?(ControlCode)
      self.class.module_eval " module ::ControlCode; end "
      Dir.glob(File.join(DEPLOYED_DIR, '*')).each do |file|
        ControlCode.module_eval(File.read(file) )
      end
    end
  end
end

