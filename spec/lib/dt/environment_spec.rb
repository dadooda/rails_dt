# frozen_string_literal: true

module DT
  describe Environment do
    use_letset(:let_a, :attrs)
    use_method_discovery :m

    let_a(:env)   # Declare for `context_when`.

    describe "public methods" do
      let(:obj) { described_class.new(attrs) }

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
            signature = Object.new
            DT.module_eval { Rails = signature }
            is_expected.to eq signature
            DT.module_eval { remove_const :Rails rescue nil }
          end
        end
      end

      describe "#root_path" do
        before :each do
          # OPTIMIZE: Make Dir an XD.
          defined?(dir_pwd) and allow(Dir).to receive(:pwd).and_return(dir_pwd)
          defined?(root_path_of_bundler) and allow(obj).to receive(:root_path_of_bundler).and_return(root_path_of_bundler)
          defined?(root_path_of_rails) and allow(obj).to receive(:root_path_of_rails).and_return(root_path_of_rails)
        end

        # Don't let our real `BUNDLE_GEMFILE` through.
        context_when env: {} do
          context_when dir_pwd: "/some/path" do
            it { is_expected.to eq Pathname("/some/path") }
          end

          context_when root_path_of_bundler: "/some/bundler/project" do
            it { is_expected.to eq Pathname("/some/bundler/project") }
          end

          context_when root_path_of_rails: "/some/project" do
            it { is_expected.to eq Pathname("/some/project") }
          end
        end
      end
    end # describe "public methods"

    describe "private methods" do
      let(:obj) { described_class.new(attrs) }

      subject { obj.send(m) }

      describe "#root_path_of_bundler" do
        before :each do
          allow(obj).to receive(:gemfile).and_return(gemfile)
        end

        context_when gemfile: nil do
          it { is_expected.to be nil }
        end

        context_when gemfile: "/path/to/Gemfile" do
          it { is_expected.to eq "/path/to" }
        end
      end

      describe "#root_path_of_rails" do
        before :each do
          allow(obj).to receive(:rails).and_return(rails)
          allow(rails).to receive(:root).and_return(rails_root) if rails
        end

        context_when rails: nil do
          it { is_expected.to be nil }
        end

        context_when rails: String.new("object"), rails_root: Pathname("/some/project") do
          it { is_expected.to eq "/some/project" }
        end
      end
    end # describe "private methods"
  end # describe
end
