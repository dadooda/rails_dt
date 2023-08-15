# frozen_string_literal: true

require_relative "../../../../libx/feature/attr_magic"
require_relative "../../../../libx/feature/initialize"
require_relative "../../eenst"

module DY; class Eenst; module Options
  class Base
    Feature::AttrMagic.load(self)
    Feature::Initialize.load(self)
  end
end; end; end
