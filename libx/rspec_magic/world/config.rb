
module RSpecMagic; module World
  module Config
    class << self
      attr_writer :spec_path

      # @return [String]
      def spec_path
        @spec_path || raise("`#{__method__}` must be configured")
      end
    end
  end
end; end
