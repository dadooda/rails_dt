# frozen_string_literal: true

require_relative "../konf"

module DT; class Konf
  class Base
    Feature::AttrMagic.load(self)
    Feature::Initialize.load(self)

    attr_writer :enabled

    # @return [Boolean] <i>(defaults to: +true+)</i>
    def enabled
      igetset(__method__) { true }
    end
  end
end; end
