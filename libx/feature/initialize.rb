
# OPTIMIZE: Specs.

module Feature
  # Provide the default initializer for the owner class.
  #
  # = Usage
  #
  # OPTIMIZE: Long overview.
  module Initialize
    # @param [Class] owner
    # @param [Boolean] private
    def self.load(owner, private: false)
      return if owner < InstanceMethodsForPrivate || owner < InstanceMethodsForPublic
      owner.send(:include, private ? InstanceMethodsForPrivate : InstanceMethodsForPublic)
    end

    module InstanceMethodsForPrivate
      # @param [Hash] attrs
      def initialize(attrs = {})
        attrs.each { |k, v| send("#{k}=", v) }
      end
    end

    module InstanceMethodsForPublic
      # @param [Hash] attrs
      def initialize(attrs = {})
        attrs.each { |k, v| public_send("#{k}=", v) }
      end
    end
  end
end
