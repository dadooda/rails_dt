# frozen_string_literal: true

require_relative "base"

module DY; module Target
  class Rails < Base
    # Print a full message.
    # @param [String] fullmsg
    def print(fullmsg)
      ::Rails.logger.debug(fullmsg)
    end
  end
end; end
