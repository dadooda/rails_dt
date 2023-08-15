
require_relative "../../../libx/feature/attr_magic"

module DY; module Target
  class Base
    Feature::AttrMagic.load(self)
    Feature::Initialize.load(self)

    # Print a full message.
    # @abstract
    # @param [String] fullmsg
    def print(fullmsg)
      raise NotImplementedError, "Redefine `#{__method__}` in your class: #{self.class}"
    end
  end
end; end
