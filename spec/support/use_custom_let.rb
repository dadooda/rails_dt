
extend_describe do
  # Define methods to manage of <tt>let</tt> variables which act as a distinct subset.
  #
  #   RSpec.describe SomeKlass do
  #     use_custom_let(:let_a, :attrs)      # (1)
  #     use_custom_let(:let_p, :params)     # (2)
  #     ...
  #
  # In above examples, (1) provides our suite with:
  #
  #   def self.let_a(let, &block)
  #   def attrs(include: [])
  #
  # , thus this now becomes possible:
  #
  #   describe "attrs" do
  #     let_a(:name) { "Joe" }
  #     let_a(:age) { 25 }
  #     let(:gender) { :male }
  #     it do
  #       expect(name).to eq "Joe"
  #       expect(age).to eq 25
  #       expect(attrs).to eq(name: "Joe", age: 25)
  #       expect(attrs(include: [:gender])).to eq(name: "Joe", age: 25, gender: :male)
  #     end
  #   end
  #
  # By not providing a block it's possible to <b>declare</b> a custom <tt>let</tt> variable
  # and be able to redefine it later via regular <tt>let</tt>. This will work:
  #
  #   describe "declarative (no block) usage" do
  #     let_a(:name)
  #
  #     subject { attrs }
  #
  #     context "when no other `let` value" do
  #       it { is_expected.to eq({}) }
  #     end
  #
  #     context "when `let`" do
  #       let(:name) { "Joe" }
  #       it { is_expected.to eq(name: "Joe") }
  #     end
  #   end
  #
  # NOTE: At the moment the feature only works if <tt>use_custom_let</tt> is invoked from a
  # top-level (<tt>RSpec.describe</tt>) context. Correct usage in sub-context is yet not possible.
  def use_custom_let(let_method, collection_method)
    class_eval %{
      def self.#{let_method}(let, &block)
        #{let_method}_keys << let
        let(let, &block) if block
      end

      def self.#{let_method}_keys
        @#{let_method}_keys ||= []
      end

      # OPTIMIZE: Consider removing `include:` altogether as we've got declarative mode now.
      def #{collection_method}(include: [])
        # NOTE: We don't store computation in a @variable since we have an argument. The result
        #   may vary.
        begin
          keys, klass = include, self.class
          begin
            keys += klass.#{let_method}_keys
          end while (klass = klass.superclass) < RSpec::Core::ExampleGroup
          # NOTE: `< RSpec::Core::ExampleGroup` is probably the reason why we can't use this in
          #   sub-contexts. The need for such use is highly questionable since this feature in
          #   effect extends RSpec syntax.

          {}.tap do |_|
            keys.uniq.each { |k| begin; _[k] = public_send(k); rescue NoMethodError; end }
          end
        end
      end
    } # class_eval
  end
end
