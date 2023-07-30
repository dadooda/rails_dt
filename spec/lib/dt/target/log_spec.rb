
module DT; module Target
  describe Log do
    use_letset(:let_a, :attrs)
    use_letset(:let_p, :pattrs)        # Private attributes.
    use_method_discovery :m

    let_a(:root_path)

    let_p(:filename)
    let_p(:formatter)
    let_p(:logger)

    let(:obj) do
      described_class.new(attrs).tap do |_|
        pattrs.each { |k, v| _.send("#{k}=", v) }
      end
    end

    describe "private methods" do
      subject { obj.send(m) }

      describe "#logger" do
        let(:lgr) { double("logger") }    # NOTE: Name is not `logger` since it's a letset attribute already.

        context_when root_path: Pathname("/some/path") do
          context "when regular" do
            it "generally works" do
              expect(Logger).to receive(:new).with(root_path + obj.send(:relative_filename)).and_return(lgr)
              expect(lgr).to receive(:formatter=).with(obj.send(:formatter))
              is_expected.to eq lgr
            end
          end

          context "when `ENOENT`" do
            it do
              expect(Logger).to receive(:new).with(root_path + obj.send(:relative_filename)).and_raise(Errno::ENOENT, "Kaboom!")
              is_expected.to be nil
            end
          end
        end
      end
      describe "#relative_filename" do
        it { is_expected.to eq "log/dt.log" }
      end
    end # describe "private methods"

    # TODO: Fin. Real end-to-end isn't possible.
    # describe "end-to-end" do
    #   let(:fullmsg) { "Hey" }
    #   let_p(:logger) { double("logger") }

    #   context_when({
    #     root_path: Pathname("/some/path"),

    #   }) do
    #     it "generally works" do
    #       # expect(Logger).to receive(:new).with("kkk").and_return logger
    #       obj.print(fullmsg)
    #     end
    #   end
    # end # describe "end-to-end"
  end # describe
end; end
