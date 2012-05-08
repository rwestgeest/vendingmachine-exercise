require 'enum'
class Choice < Enum
  values :cola
end
class Can < Enum
  values :cola
end
class Bin
  def initialize
    @content = []
  end
  def catch(can)
    @content << can
  end
  def include?(can)
    return @content.include?(can)
  end
end

class VendingMachine
  def initialize bin
    @bin = bin
  end
  def choose(choice)
    @bin.catch(Can.cola)
  end
end

