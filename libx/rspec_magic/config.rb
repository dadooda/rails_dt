# frozen_string_literal: true

"LODoc"

module RSpecMagic
  # Shared configuration.
  module Config
    class << self
      attr_writer :spec_path

      # @return [String]
      def spec_path
        @spec_path || raise("`#{__method__}` must be configured")
      end
    end
  end
end
