
module DT
  # # NOTE: Fake Rails module.
  # module Rails; end

  describe Environment do
    use_method_discovery :m

    # OPTIMIZE: `let_a` or something.
    let(:attrs) { {} }

    describe "public methods" do
      subject { described_class.new(attrs).public_send(m) }

      describe "#bundle_gemfile" do
        context "when env" do
          let(:attrs) { { env: { "BUNDLE_GEMFILE" => "/path/to/Gemfile" } } }
          it { is_expected.to eq "/path/to/Gemfile" }
        end

        context "when set" do
          pending("")
        end
      end

      describe "#env" do
        it { is_expected.to be_a Hash }
      end

      context "when Rails" do
        describe "#rails" do
          context "when plain" do
            it do
              DT.module_eval { remove_const :Rails rescue nil }
              is_expected.to be nil
            end
          end

          context "when Rails" do
            it do
              DT.module_eval { Rails = :signature }
              is_expected.to eq :signature
            end
          end

          context "when set" do
            let(:attrs) { { rails: :something } }
            it { is_expected.to eq :something }
          end
        end
      end
    end # public methods
  end
end
