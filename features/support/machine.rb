require 'drb'

module Machine
  URI = "druby://localhost:14567"

  def self.proxy
    DRbObject.new(nil, URI)
  end
end

