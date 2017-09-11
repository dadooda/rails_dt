
module DT
  describe Instance do
    # OPTIMIZE: Make this shared.
    let(:cllggr) do
      # Instance of this class logs every method call and allows to retrieve the calls.
      # @see #_calls
      Class.new do
        # Calls logger so far.
        # @return [Array]
        def _calls
          @_calls ||= []
        end

        def method_missing(m, *args, &block)
          _calls << [m, args, block].compact
        end
      end
    end

    # OPTIMIZE: Make this shared.
    describe "cllggr" do
      it "generally works" do
        r = cllggr.new
        r.do_this(1)
        block = -> { puts "fake" }
        r.do_that(2, 3, &block)
        expect(r._calls).to eq [[:do_this, [1]], [:do_that, [2, 3], block]]
      end
    end

    describe "#rails_logger" do
      it "is no longer available" do
        r = described_class.new
        expect { r.rails_logger = "obj" }.to raise_error NoMethodError
        expect { r.rails_logger }.to raise_error NoMethodError
      end
    end

    describe "#_p" do
      it "generally works" do
        r = described_class.new(
          conf: Config.new(
            rails: nil,
            root_path: "/some/path",
          ),
          stderr: StringIO.new,
          dt_logger: (dt_logger = cllggr.new),
        )

        clr = [
          "/some/path/lib/file2:20 in `method2'",
          "/some/path/lib/file1:10 in `method1'"
        ]

        r._p(clr, "Message")
        lines = r.stderr.tap(&:rewind).to_a
        expect(lines).to eq ["[DT lib/file2:20 in `method2'] Message\n"]

        expect(dt_logger._calls).to eq [[:debug, ["[DT lib/file2:20 in `method2'] Message"]]]
      end
    end
  end
end
