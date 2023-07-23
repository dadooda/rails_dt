
module DT
  describe Config do
    use_letset(:let_a, :attrs)
    use_method_discovery :m

    let(:obj) { described_class.new(attrs) }

    subject { obj.send(m) }

    describe "#env" do
      it { is_expected.to eq ENV.to_h }
    end

    describe "#rails" do
      let_a(:rails)
      # NOTE: We can't reliably test for constant probing since `defined?` is a language keyword.
      context_when rails: :signature do
        it { is_expected.to eq :signature }
      end
    end

    describe "#root_path" do
      let(:pathname_double) { double "Pathname(raw_path)" }
      let_a(:env)
      let_a(:rails)

      before :each do
        expect(obj).to receive(:Pathname).with(raw_path).once.and_return(pathname_double)
        expect(pathname_double).to receive(:realpath).once.and_return(:signature)
      end

      context "when Rails" do
        let(:raw_path) { Pathname("/path/to/project") }
        let_a(:rails) { double "rails" }
        it do
          expect(rails).to receive(:root).once.and_return(raw_path)
          is_expected.to eq :signature
        end
      end

      context_when rails: nil do
        context do
          let(:bundle_gemfile) { self.class.bundle_gemfile }
          let(:raw_path) { self.class.raw_path }

          define_singleton_method(:raw_path) { "/path/to/project" }
          define_singleton_method(:bundle_gemfile) { "#{raw_path}/Gemfile"}

          context_when env: {"BUNDLE_GEMFILE" => bundle_gemfile } do
            it { is_expected.to eq :signature }
          end
        end

        context_when env: {} do
          let(:raw_path) { Dir.pwd }
          it do
            subject
          end
        end
      end
    end # describe "#root_path"

    describe "#root_path=" do
      let_a(:root_path)

      subject { obj.root_path }

      context_when root_path: "/some/path" do
        it { is_expected.to eq Pathname("/some/path") }
      end
    end
  end # describe
end
