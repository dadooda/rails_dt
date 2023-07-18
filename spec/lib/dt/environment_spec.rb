
module DT
  describe Environment do
    use_letset(:let_a, :attrs)
    use_method_discovery :m

    describe "public methods" do
      subject { described_class.new(attrs).public_send(m) }

      describe "#env" do
        context "when default" do
          it { is_expected.to be_a Hash }
        end

        context "when set" do
          let_a(:env) { :signature }
          it { is_expected.to eq :signature }
        end
      end

      describe "#gemfile" do
        let_a(:env) { { "BUNDLE_GEMFILE" => "/path/to/Gemfile" } }
        it { is_expected.to eq "/path/to/Gemfile" }
      end
    end # describe "public methods"
  end # describe
end
