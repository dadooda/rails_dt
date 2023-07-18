# frozen_string_literal: true

require_relative "../../libx/feature/attr_magic"
require_relative "../../libx/feature/initialize"

"LODoc"

module DT
  # The configuration object.
  class Konf
    Feature::AttrMagic.load(self)
    Feature::Initialize.load(self)

    attr_writer :format

    # Message format. Available tokens:
    #
    # * +%{full_loc} — non-abbreviated, variable-length location
    # * +%{loc}+ — fixed-length location
    # * +%{msg}+ — message
    #
    # @return [String] <i>(defaults to: <tt>"[DT %{loc}] %{msg}"</tt>)</i>
    def format
      @format ||= "[DT %{loc}] %{msg}"
    end
  end
end
