
module DT; module Target
  describe Console do
    use_method_discovery :m

    let(:obj) { described_class.new }

    describe "function methods" do
      subject { obj.public_send(m, *(defined?(args) ? args : [])) }

      describe "#print" do
        let(:stderr) { double("stderr") }

        before :each do
          expect(obj).to receive(:xd_stderr).and_return(stderr)
        end

        context_when args: ["Hey there"] do
          it do
            expect(stderr).to receive(:puts).with(args[0])
            subject
          end
        end
      end
    end

    # OPTIMIZE: Make this a shared oneliner. Better be RSpecMagic.
    it "is inherited from `Base`" do
      expect(described_class.superclass).to be Base
    end
  end # describe
end; end
