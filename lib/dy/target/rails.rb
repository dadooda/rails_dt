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
      require_attr :rails
      rails.logger.debug(fullmsg)
    end
  end
end; end
