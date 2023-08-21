
module DY; class Config
  describe Base do
    use_letset(:let_a, :attrs)
    use_method_discovery :m

    let_a(:enabled)

    let(:klass) { Class.new(described_class) }    # Inherit, just like the successor would do.
    let(:obj) { klass.new(attrs) }

    subject { obj.public_send(m) }

    describe "#enabled" do
      context "default" do
        it { is_expected.to be true }
      end

      context_when enabled: false do
        it { is_expected.to be false }
      end
    end

    describe "#enable!" do
      pending("TODO")
    end

    describe "#disable!" do
      pending("TODO")
    end
  end
end; end
