# frozen_string_literal: true

require_relative "base"

module DT; module Target
  class Console < Base
    # Print a full message.
    # @param [String] fullmsg
    def print(fullmsg)
      STDERR.puts(fullmsg)
    end
  end
end; end
