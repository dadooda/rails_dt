
"LODoc"

# OPTIMIZE: Fix doc consistency.

module Feature
  # Provide attribute manipulation methods to the owner class.
  #
  # = Usage
  #
  #   class Klass
  #     Feature::AttrMagic.load(self)
  #   end
  #
  # = Features
  #
  # == Get/set instance variables on the fly
  #
  # Ruby's <tt>||=</tt> works nicely with object instances, but requires special bulky treatment
  # for <tt>nil</tt> and <tt>false</tt>. For example, this will cause a hidden glitch:
  #
  #   def verbose?
  #     @is_verbose ||= begin
  #       ENV["VERBOSE"] == "y"
  #     end
  #   end
  #
  # The <tt>begin … end</tt> code will be evaluated every time if the value of computation is <tt>false</tt>.
  #
  # Known solutions to this problem involve calling <tt>instance_variable_*</tt> a few times per attribute accessor.
  #
  # <tt>#igetset</tt> does the job for you. All you have to do is specify a block to compute the value.
  #
  #   igetset(:is_verbose) { ENV["VERBOSE"] == "y" }
  #
  # See {InstanceMethods#igetset}, {InstanceMethods#igetwrite}.
  #
  # == Require attribute to be set
  #
  # Methods which use other methods to do the computation, can often assist in strengthening the code by declaring
  # and checking if the dependable value is present or otherwise "good". For this purpose, #require_attr comes in
  # handy. Say,
  #
  #   def full_name
  #     require_attr :first_name
  #     require_attr :last_name
  #
  #     [first_name, last_name].join(" ")
  #   end
  #
  # , or:
  #
  #   def full_name
  #     [
  #       require_attr(:first_name, :present?),
  #       require_attr(:last_name, :present?),
  #     ].join(" ")
  #   end
  #
  # See {InstanceMethods#require_attr}.
  module AttrMagic
    # @param owner [Class]
    def self.load(owner)
      return if owner < InstanceMethods

      owner.send(:include, InstanceMethods)

      # Tune imported method visibility.
      owner.class_eval do
        private :igetset, :igetwrite, :require_attr
      end
    end

    module InstanceMethods
      # Get/set an instance variable on the fly, given its computation block.
      # @param [String] name
      # @see #igetwrite
      def igetset(name, &compute)
        if instance_variable_defined?(k = "@#{name}")
          instance_variable_get(k)
        else
          instance_variable_set(k, compute.call)
        end
      end

      # Same as {#igetset}, but this one calls the attribute writer in case instance variable is
      # missing.
      #
      #   igetwrite(:name) { "Joe" }
      #
      # , is identical to:
      #
      #   @name || self.name = "Joe"
      #
      # @see #igetset
      def igetwrite(name, &compute)
        if instance_variable_defined?(k = "@#{name}")
          instance_variable_get(k)
        else
          send("#{name}=", compute.call)
        end
      end

      # Require attribute to be set, present, be otherwise "good" or not be otherwise "bad".
      #
      #   require_attr(name)                  # Require not to be `nil?`.
      #   require_attr(items, :not_empty?)    # Require not to be `empty?`.
      #   require_attr(items, :present?)      # Require to be `present?`.
      #   require_attr(obj, :is_valid)        # Require to be `is_valid`.
      #
      # @param name [Symbol]
      # @param predicate [String]
      # @return [mixed] Attribute value.
      def require_attr(name, predicate = "not_nil?")
        m, true2fail = if ((sp = predicate.to_s).start_with? "not_")
          [sp[4..-1], true]
        else
          [sp, false]
        end

        raise ArgumentError, "Invalid predicate: #{predicate.inspect}" if m.empty?

        send(name).tap do |res|
          # NOTE: `true2fail` turns `if` to `if not` by applying a `XOR true`.
          if res.send(m) ^ !true2fail
            raise "Attribute `#{name}` must#{' not' if true2fail} be #{m.chomp('?')}: #{res.inspect}"
          end
        end
      end
    end # InstanceMethods
  end
end
