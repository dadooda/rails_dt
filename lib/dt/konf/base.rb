# frozen_string_literal: true

require_relative "../konf"

module DT; class Konf
  # @note OPTIMIZE: Document this. A funny case of a LODoc of a base class.
  class Base
    Feature::AttrMagic.load(self)
    Feature::Initialize.load(self)

    attr_writer :enabled

    # Disable the target.
    def disable
      self.enabled = false
    end

    # Enable the target.
    def enable
      self.enabled = true
    end

    # +true+ if the target is enabled.
    # @return [Boolean] <i>(defaults to: +true+)</i>
    def enabled
      igetset(__method__) { true }
    end
  end
end; end
