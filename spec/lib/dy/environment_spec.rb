
module DY
  describe Environment do
    use_letset(:let_a, :attrs)
    use_letset(:let_p, :pattrs)
    use_method_discovery :m

    let_a(:env)
    let_p(:rails)
    # TODO: CUP.
    # let_p(:is_rails)

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

      # TODO: Fin.
      # xdescribe "#rails?" do
      #   context "when plain" do
      #     it { is_expected.to be false }
      #   end

      #   context "when Rails" do
      #     it do
      #       signature = Object.new
      #       DY.module_eval { Rails = signature }
      #       is_expected.to be true
      #       DY.module_eval { remove_const :Rails rescue nil }
      #     end
      #   end
      # end

      describe "#rails" do
        context "when plain" do
          it { is_expected.to be nil }
        end

        context "when Rails" do
          it do
            signature = Object.new
            DY.module_eval { Rails = signature }
            is_expected.to eq signature
            DY.module_eval { remove_const :Rails rescue nil }
          end
        end
      end

      describe "#root_path", { focus: true } do
        # TODO: Use attributes.
        before :each do
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

      # TODO: Fin.
      # describe "#root_path_of_rails_G" do
      #   before :each do
      #     # allow(obj).to receive(:rails).and_return(rails)
      #     allow(::Rails).to receive(:root).and_return(rails_root) if rails_root
      #   end

      #   context_when is_rails: false do
      #     it { is_expected.to be nil }
      #   end

      #   context_when is_rails: true, rails_root: Pathname("/some/project") do
      #     it { is_expected.to eq "/some/project" }
      #   end
      # end
    end # describe "private methods"
  end # describe
end
