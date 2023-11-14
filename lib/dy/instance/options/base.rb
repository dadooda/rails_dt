# frozen_string_literal: true

require "attr_magic"

require_relative "../../instance"

module DY; class Instance; module Options
  class Base
    AttrMagic.load(self)
    DY::Feature::Initialize.load(self)
  end
end; end; end
