# frozen_string_literal: true

require "attr_magic"
require_relative "../../../../libx/feature/initialize"
require_relative "../../instance"

module DY; class Instance; module Options
  class Base
    AttrMagic.load(self)
    Feature::Initialize.load(self)
  end
end; end; end
