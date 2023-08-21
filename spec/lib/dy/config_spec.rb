
module DY
  describe Config do
    use_letset(:let_a, :attrs)
    use_method_discovery :m

    subject { described_class.new(attrs).public_send(m) }

    describe "#console" do
      it { is_expected.to be_a described_class::Console }
    end

    describe "#format" do
      let_a(:format)

      context "when default" do
        it { is_expected.to eq "(DT %{loc}) %{msg}" }
      end

      context_when format: "signature" do
        it { is_expected.to eq "signature" }
      end
    end

    describe "#log" do
      it { is_expected.to be_a described_class::Log }
    end

    describe "#rails" do
      it { is_expected.to be_a described_class::Rails }
    end
  end
end
