require 'drb'
module CommandProcessor
  URI = "druby://localhost:14567"

  def self.run_server(commands)
    DRb.start_service(URI,commands)
  end

  def self.client
    DRbObject.new(nil, URI)
  end
end

