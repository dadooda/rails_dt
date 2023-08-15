
require_relative "base"

module DY; class Eenst; module Options
  # Validated options for {Eenst#do_p}.
  class DoP < Base
    # The prefix to each output +%{msg}+ token.
    # @return [String]
    attr_accessor :prefix
  end
end; end; end
