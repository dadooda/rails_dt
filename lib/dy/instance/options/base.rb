# frozen_string_literal: true

require_relative "../../../../libx/feature/attr_magic"
require_relative "../../../../libx/feature/initialize"
require_relative "../../instance"

module DY; class Instance; module Options
  class Base
    Feature::AttrMagic.load(self)
    Feature::Initialize.load(self)
  end
end; end; end
