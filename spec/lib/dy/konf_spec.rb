
module DY
  describe Konf do
    use_letset(:let_a, :attrs)
    use_method_discovery :m

    subject { described_class.new(attrs).public_send(m) }

    describe "#format" do
      let_a(:format)

      context "when default" do
        it { is_expected.to eq "[DT %{loc}] %{msg}" }
      end

      context_when format: "signature" do
        it { is_expected.to eq "signature" }
      end
    end
  end
end
