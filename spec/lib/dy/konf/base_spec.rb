
module DY; class Konf
  describe Base do
    use_letset(:let_a, :attrs)
    use_method_discovery :m

    let(:klass) { Class.new(described_class) }    # Inherit, just like the successor would do.
    let(:obj) { klass.new(attrs) }

    describe "attributes" do
      subject { obj.public_send(m) }

      describe "#enabled" do
        let_a(:enabled)

        context "default" do
          it { is_expected.to be true }
        end

        context_when enabled: false do
          it { is_expected.to be false }
        end
      end
    end
  end
end; end
