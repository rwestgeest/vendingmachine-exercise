require 'fileutils'
module Deploy
  class Deployer
    DEPLOYED_DIR = File.expand_path("~/.vendingmachine")
    def deploy(file_path)
      FileUtils.cp file_path, File.join(DEPLOYED_DIR, File.basename(file_path))
      require File.join(DEPLOYED_DIR, File.basename(file_path))
    end

  end
end
