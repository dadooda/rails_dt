# frozen_string_literal: true

require_relative "base"

module DY; module Target
  class Rails < Base
    # The Rails module, as provided by {Environment#rails}.
    # @return [Module]
    attr_accessor :rails

    # Print a full message.
    # @param [String] fullmsg
    def print(fullmsg)
      # Rails is procedural and CAN be in a state where `Rails.logger` is nil.
      # Check it upon every invocation to prevent unwanted crashes.
      # For the same reason we'd rather not memoize `rails.logger` into a lazy attribute.
      logger = require_attr(:rails).logger
      if logger
        logger.debug(fullmsg)
      else
        # OPTIMIZE: Provide test coverage.
        "hop, hey hop"
      end
    end
  end
end; end
