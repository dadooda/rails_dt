
"LODoc"

module DY; module Feature
  # Provide the default initializer for the owner class.
  #
  # = Usage
  #
  #   class Person
  #     Feature::Initialize.load(self)
  #     attr_accessor :first_name, :last_name
  #   end
  #
  #   Person.new(first_name: "Alice", last_name: "Roberts")
  module Initialize
    # @param [Class] owner
    def self.load(owner)
      return if owner < InstanceMethods
      owner.send(:include, InstanceMethods)
    end

    module InstanceMethods
      # @param [Hash] attrs
      def initialize(attrs = {})
        attrs.each { |k, v| public_send("#{k}=", v) }
      end
    end
  end
end; end
