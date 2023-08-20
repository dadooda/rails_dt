# frozen_string_literal: true

require_relative "do_p"

module DY; class Instance; module Options
  # Validated options for {Instance#fn}.
  class Fn < DoP
    # Set to +true+ to mute all output.
    # @return [Boolean]
    attr_accessor :mute
  end
end; end; end
