# frozen_string_literal: true

require_relative "../config"
require_relative "../feature/initialize"

module DY; class Config
  # OPTIMIZE: Document this. A funny case of a LODoc of a base class.
  class Base
    AttrMagic.load(self)
    DY::Feature::Initialize.load(self)

    attr_writer :enabled

    # Disable the target.
    def disable!
      self.enabled = false
    end

    # Enable the target.
    def enable!
      self.enabled = true
    end

    # +true+ if the target is enabled.
    # @return [Boolean] <i>(defaults to: +true+)</i>
    def enabled
      igetset(__method__) { true }
    end
  end
end; end
