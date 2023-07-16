
"LODoc"

module RSpecMagic
  # Create a self-descriptive "when …" context with one or more +let+ variables defined.
  #
  # = Usage
  #
  # The following:
  #
  #   context_when name: "Joe", age: 25 do
  #     …
  #   end
  #
  # is identical to:
  #
  #   context "when { name: \"Joe\", age: 25 }" do
  #     let(:name) { "Joe" }
  #     let(:age) { 25 }
  #     …
  #   end
  #
  # = Features
  #
  # Prepend +x+ to +context_when+ to exclude it:
  #
  #   xcontext_when … do
  #     …
  #   end
  #
  # OPTIMIZE: On +Proc+.
  module ContextWhen
    # Default formatter for {#context_when}. Redefine at the context level if needed.
    #
    #   describe "…" do
    #     def self._context_when_formatter(h)
    #       # Your custom formatter here.
    #       h.to_json
    #     end
    #
    #     context_when … do
    #       …
    #     end
    #   end
    # @param [Hash] h
    # @return [String]
    # @see #context_when
    def _context_when_formatter(h)
      # OPTIMIZE: Add tests for the formatter specifically.

      # Extract labels for Proc arguments, if any.
      labels = {}
      h.each do |k, v|
        if v.is_a? Proc
          begin
            labels[k] = h.fetch(lk = "#{k}_label".to_sym)
            h.delete(lk)
          rescue KeyError
            raise ArgumentError, "`#{k}` is a `Proc`, `#{k}_label` must be given"
          end
        end
      end

      pcs = h.map do |k, v|
        [
          k.is_a?(Symbol) ? "#{k}:" : "#{k.inspect} =>",
          v.is_a?(Proc) ? labels[k] : v.inspect,
        ].join(" ")
      end

      "when { " + pcs.join(", ") + " }"
    end

    # Create a context.
    # @param [Hash] h
    # @see #xcontext_when
    def context_when(h, &block)
      context _context_when_formatter(h) do
        h.each do |k, v|
          if v.is_a? Proc
            let(k, &v)
          else
            # Generic scalar value.
            let(k) { v }
          end
        end
        class_eval(&block)
      end
    end

    # Create a temporarily excluded context.
    # @see #context_when
    def xcontext_when(h, &block)
      xcontext _context_when_formatter(h) { class_eval(&block) }
    end
  end

  defined?(::RSpec) and ::RSpec.configure do |config|
    config.extend ContextWhen
  end
end
