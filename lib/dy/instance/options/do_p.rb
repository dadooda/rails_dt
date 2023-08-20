
require_relative "base"

module DY; class Instance; module Options
  # Validated options for {Instance#do_p}.
  class DoP < Base
    # The prefix to each output +%{msg}+ token.
    # @return [String]
    attr_accessor :prefix
  end
end; end; end
