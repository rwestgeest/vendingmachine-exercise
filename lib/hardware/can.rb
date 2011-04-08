require 'enum'

module Hardware
  class Can < Enum
    values :cola, :fanta, :sprite, :sisi
    def to_s
      "can of #{@type}"
    end
  end
end

