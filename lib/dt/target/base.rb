
require_relative "../../../libx/feature/attr_magic"

module DT; module Target
  class Base
    Feature::AttrMagic.load(self)
    Feature::Initialize.load(self)

    # @abstract
    # @param [String] fullmsg
    # @return [nil]
    def print(fullmsg)
      raise NotImplementedError, "Redefine `#{__method__}` in your class: #{self.class}"
    end
  end
end; end
