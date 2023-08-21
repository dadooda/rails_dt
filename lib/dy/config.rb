# frozen_string_literal: true

require_relative "../../libx/feature/attr_magic"
require_relative "../../libx/feature/initialize"
require_relative "config/console"
require_relative "config/log"
require_relative "config/rails"

module DY
  # The configuration object.
  class Config
    Feature::AttrMagic.load(self)
    Feature::Initialize.load(self)

    attr_writer :console, :format, :loc_length

    # Configuration for the named target.
    # @return [Console]
    def console
      igetset(__method__) { Console.new }
    end

    # Message format. Available tokens:
    #
    # * +%{full_loc}+ — non-abbreviated, variable-length location
    # * +%{loc}+ — fixed-length location
    # * +%{msg}+ — message or value
    #
    # @return [String] <i>(defaults to: <tt>"[DT %{loc}] %{msg}"</tt>)</i>
    def format
      igetset(__method__) { "(DT %{loc}) %{msg}" }
    end

    # +%{loc}+ token length.
    # @return [Fixnum] <i>(defaults to: 30)</i>
    def loc_length
      igetset(__method__) { 30 }
    end

    # Configuration for the named target.
    # @return [Log]
    def log
      igetset(__method__) { Log.new }
    end

    # Configuration for the named target.
    # @return [Rails]
    def rails
      igetset(__method__) { Rails.new }
    end
  end
end
