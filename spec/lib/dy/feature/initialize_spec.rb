
module DY; module Feature
  describe Initialize do
    use_letset :let_a, :attrs

    let_a(:private_attr)
    let_a(:protected_attr)
    let_a(:public_attr)

    let(:klass) do
      mod = described_class
      Class.new do
        mod.load(self)
        # NOTE: Logical order.
        attr_accessor :public_attr
        protected; attr_accessor :protected_attr
        private; attr_accessor :private_attr
      end
    end

    subject { klass.new(attrs) }

    # NOTE: Logical order.

    context_when public_attr: "hehe" do
      it do
        is_expected.to have_attributes(
          public_attr: public_attr,
        )
      end
    end

    context_when protected_attr: "hehe" do
      it do
        expect { subject }.to raise_error(NoMethodError, /protected method.+called/)
      end
    end

    context_when private_attr: "hehe" do
      it do
        expect { subject }.to raise_error(NoMethodError, /private method.+called/)
      end
    end
  end
end; end
