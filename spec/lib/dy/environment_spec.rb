
module DY
  describe Environment do
    use_letset(:let_a, :attrs)
    use_letset(:let_p, :pattrs)
    use_method_discovery :m

    let_p(:env)
    let_p(:gemfile)
    let_p(:pwd)
    let_p(:rails)
    let_p(:root_path_of_bundler)
    let_p(:root_path_of_rails)
    let_p(:root_path)

    let(:obj) do
      described_class.new(attrs).tap do |_|
        pattrs.each { |k, v| _.send("#{k}=", v) }
      end
    end

    describe "public methods" do
      subject { obj.public_send(m) }

      describe "#env" do
        context "when default" do
          it { is_expected.to be_a Hash }
          it { is_expected.to include "PATH" }
        end

        context_when env: { "signature" => "*" } do
          it { is_expected.to eq({ "signature" => "*" }) }
        end
      end

      describe "#gemfile" do
        context_when env: {} do
          it { is_expected.to be nil}
        end

        context_when env: { "BUNDLE_GEMFILE" => "/path/to/Gemfile" } do
          it { is_expected.to eq "/path/to/Gemfile" }
        end
      end

      describe "#rails" do
        context "when plain" do
          it { is_expected.to be nil }
        end

        context "when Rails" do
          it do
            signature = double "Rails"
            DY.module_eval { Rails = signature }
            is_expected.to eq signature
            DY.module_eval { remove_const :Rails rescue nil }
          end
        end
      end

      describe "#root_path", focus: true do
        context_when pwd: "/some/path", root_path_of_bundler: nil, root_path_of_rails: nil do
          it { is_expected.to eq Pathname(pwd) }

          context_when root_path_of_bundler: "/some/bundler/project" do
            it { is_expected.to eq Pathname(root_path_of_bundler) }

            context_when root_path_of_rails: "/some/rails/project" do
              it { is_expected.to eq Pathname(root_path_of_rails) }
            end
          end
        end
      end
    end # describe "public methods"

    describe "private methods" do
      subject { obj.send(m) }

      describe "#root_path_of_bundler" do
        context_when gemfile: nil do
          it { is_expected.to be nil }
        end

        context_when gemfile: "/path/to/Gemfile" do
          it { is_expected.to eq "/path/to" }
        end
      end

      describe "#root_path_of_rails" do
        context_when rails: nil do
          it { is_expected.to be nil }
        end

        context "when rails" do
          let(:rails) { double("rails") }

          it do
            expect(rails).to receive(:root).and_return(Pathname("/some/project"))
            is_expected.to eq "/some/project"
          end
        end
      end
    end # describe "private methods"
  end # describe
end
