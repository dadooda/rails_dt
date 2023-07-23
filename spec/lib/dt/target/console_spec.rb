
module DT; module Target
  describe Console do
    use_method_discovery :m

    let(:obj) { described_class.new }

    describe "function methods" do
      subject { obj.public_send(m, *(defined?(args) ? args : [])) }

      describe "#print" do
        context_when args: ["Hey there"] do
          let(:stderr) { double("stderr") }

          it "generally works" do
            expect(obj).to receive(:xd_stderr).and_return(stderr)
            expect(stderr).to receive(:puts).with("Hey there")
            subject
          end
        end
      end
    end
  end # describe
end; end
