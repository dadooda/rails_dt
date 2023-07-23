
module DT
  RSpec.describe Instance do
    use_letset(:let_a, :attrs)
    use_method_discovery :m

    let(:obj) { described_class.new(attrs) }

    subject { obj.send(m) }

    describe "attributes" do
      describe "#conf" do
        it do
          expect(DT).to receive(:conf).once.and_return(:signature)
          is_expected.to eq :signature
        end
      end

      describe "#dt_logger" do
        it do
          expect(Logger).to receive(:new).and_return(:signature)
          expect(subject).to eq :signature
        end
      end

      describe "#is_rails_console" do
        let_a(:conf) { double "conf" }
        let(:rails_double) { double "rails" }

        before :each do
          expect(conf).to receive(:rails).at_least(:once).and_return(rails_double)
          expect(rails_double).to receive(:const_defined?).with(:Console).and_return(is_const_defined)
        end

        context_when is_const_defined: true do
          it { is_expected.to be true }
        end

        context_when is_const_defined: false do
          it { is_expected.to be false }
        end
      end

      describe "#rails_logger" do
        let_a(:conf) { double "conf" }

        context "when Rails mode" do
          let(:rails_double) { double "rails" }

          it do
            expect(conf).to receive(:rails).at_least(:once).and_return(rails_double)
            expect(rails_double).to receive(:logger).and_return(:signature)
            expect(subject).to eq :signature
          end
        end

        context "when non-Rails mode" do
          it do
            expect(conf).to receive(:rails).at_least(:once).and_return(nil)
            expect(subject).to be nil
          end
        end
      end

      describe "#stderr" do
        it { is_expected.to eq STDERR }
      end

      it { expect(obj).to alias_method(:rails_console?, :is_rails_console) }
    end # describe "attributes"

    describe "actions" do
      describe "#_p" do

        let_a(:conf) { Config.new(root_path: "/some/path") }
        let_a(:is_rails_console)

        # Output channels.
        let_a(:dt_logger) { double "dt_logger" }        # "1".
        let_a(:rails_logger) { double "rails_logger" }  # "2".
        let_a(:stderr) { double "stderr" }      # This one is a "backup" output channel which pairs with `rails_logger`.

        let(:args) { ["Message", {kk: 12}] }
        let(:caller) do
          [
            "/some/path/lib/file2:20 in `method2'",
            "/some/path/lib/file1:10 in `method1'",
          ]
        end
        let(:msg1) { "#{pfx} Message" }
        let(:msg2) { "#{pfx} {:kk=>12}"}
        let(:pfx) { "[DT lib/file2:20 in `method2']" }

        subject { obj.send(m, caller, *args) }

        # Disable output channels in combos to leave out just one.
        # Order: dt_logger, rails_logger, stdout (via `is_rails_console`).

        def expect_to_dt
          expect(dt_logger).to receive(:debug).once.with(msg1)
          expect(dt_logger).to receive(:debug).once.with(msg2)
        end

        def expect_to_rails
          expect(rails_logger).to receive(:debug).once.with(msg1)
          expect(rails_logger).to receive(:debug).once.with(msg2)
        end

        def expect_to_stderr
          expect(stderr).to receive(:puts).once.with(msg1)
          expect(stderr).to receive(:puts).once.with(msg2)
        end

        # Disable 1.
        context_when dt_logger: nil do
          context_when is_rails_console: true do
            it do
              expect_to_rails
              subject
            end
          end

          it do
            expect_to_rails
            expect_to_stderr
            subject
          end
        end

        # Disable 2.
        context_when rails_logger: nil do
          it do
            expect_to_dt
            expect_to_stderr
            subject
          end
        end

        # Disable 1 and 2.
        context_when dt_logger: nil, rails_logger: nil do
          it do
            expect_to_stderr
            subject
          end
        end

        # Disable all.
        context_when dt_logger: nil, rails_logger: nil, stderr: nil do
          it "generally works" do
            # Just expect nothing to crash by using `nil`.
            # RSpec negative expectations are warned against (which I think is right).
            subject
          end
        end

        # Generic case, all channels enabled.
        context_when is_rails_console: false do
          it do
            expect_to_dt
            expect_to_rails
            expect_to_stderr
            subject
          end
        end
      end
    end
  end
end
