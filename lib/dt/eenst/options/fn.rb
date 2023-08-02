# frozen_string_literal: true

require_relative "do_p"

module DT; class Eenst; module Options
  # Validated options for {Eenst#fn}.
  class Fn < DoP
    # Set to +true+ to mute all output.
    # @return [Boolean]
    attr_accessor :mute
  end
end; end; end
