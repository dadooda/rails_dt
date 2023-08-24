
require_relative "../../libx/feature/attr_magic"

module Feature
  RSpec.describe AttrMagic do
    use_method_discovery :m

    describe "#iget*" do
      let(:klass) do
        feature = described_class
        Class.new do
          feature.load(self)

          attr_writer :c

          def a
            igetset(:a) do
              calls << :a_block
              false
            end
          end

          def b
            igetset(:b) do
              calls << :b_block
              nil
            end
          end

          def c
            igetwrite(:c) do
              calls << :c_block
              "c"
            end
          end

          def c=(value)
            calls << :c_writer
            @c = value + "!"      # Custom modification by the writer.
          end

          def calls
            @log ||= []
          end
        end
      end

      describe "#igetset" do
        it "generally works" do
          obj = klass.new
          expect(obj.calls).to eq []
          expect(obj.a).to be false
          expect(obj.a).to be false
          expect(obj.calls).to eq [:a_block]

          obj = klass.new
          expect(obj.calls).to eq []
          expect(obj.b).to be nil
          expect(obj.b).to be nil
          expect(obj.calls).to eq [:b_block]
        end
      end # describe "#igetset"

      describe "#igetwrite" do
        it "generally works" do
          obj = klass.new
          expect(obj.calls).to eq []
          expect(obj.c).to eq "c!"
          expect(obj.c).to eq "c!"
          expect(obj.c).to eq "c!"
          expect(obj.calls).to eq [:c_block, :c_writer]
        end
      end # describe "#igetwrite"
    end # describe "iget*"

    describe "#require_attr" do
      let(:klass) do
        feature = described_class
        Class.new do
          feature.load(self)

          attr_accessor :a

          def initialize(attrs = {})
            attrs.each { |k, v| public_send("#{k}=", v) }
          end
        end
      end

      let(:obj) { klass.new(a: value) }

      subject { obj.send(m, :a, predicate) }

      context "when valid arguments" do
        # NOTE: We don't nest contexts and provide a linear sequence of [value, predicate] for
        #       smarter reporting.
        context_when value: nil do
          subject { obj.send(m, :a) }
          it { expect { subject }.to raise_error(RuntimeError, "Attribute `a` must not be nil: nil") }
        end

        context_when value: nil, predicate: "not_nil?" do
          it { expect { subject }.to raise_error(RuntimeError, "Attribute `a` must not be nil: nil") }
        end

        context_when value: [], predicate: "not_empty?" do
          it { expect { subject }.to raise_error(RuntimeError, "Attribute `a` must not be empty: []") }
        end

        context_when value: 1, predicate: "odd?" do
          it { is_expected.to eq 1 }
        end

        context_when value: 1, predicate: "even?" do
          it { expect { subject }.to raise_error(RuntimeError, "Attribute `a` must be even: 1") }
        end

        context_when value: [], predicate: "is_valid" do
          let(:a_double) { double "a" }
          it do
            expect(obj).to receive(:a).and_return(a_double)
            expect(a_double).to receive(:is_valid).and_return(false)
            expect { subject }.to raise_error(RuntimeError, /must be is_valid/)
          end
        end

        # NOTE: This is a valid case in a duck-typed language which Ruby is.
        context_when value: [], predicate: "joyful?" do
          it { expect { subject }.to raise_error(NoMethodError, /joyful\?/) }
        end
      end # context "when valid arguments"

      context "when invalid arguments" do
        context_when value: [], predicate: "" do
          it { expect { subject }.to raise_error(ArgumentError, /Invalid predicate/) }
        end

        context_when value: [], predicate: "not_" do
          it { expect { subject }.to raise_error(ArgumentError, /Invalid predicate/) }
        end
      end
    end # describe "#require_attr"
  end # describe
end
