
module DT
  describe Eenst do
    use_letset(:let_a, :attrs)
    use_method_discovery :m

    let(:obj) { described_class.new(attrs) }

    describe "public methods" do
      subject { obj.public_send(m, *(defined?(args) ? args : [])) }

      describe "#_p1" do
        let_a(:konf) { double("konf") }

        before :each do
          # OPTIMIZE: Retro-fix siblings to use streamlined names for mocked results.
          defined?(of_konf_format) and allow(konf).to receive(:format).and_return(of_konf_format)
          defined?(of_make_tokens) and allow(obj).to receive(:make_tokens).with(args[0], args[1]).and_return(of_make_tokens)
        end

        context_when({
          # Lengthy arguments set.
          args: ["some-caller", "hey"],
          of_konf_format: "[dt]%{full_loc}|%{loc}|%{msg}[/dt]",
          of_make_tokens: { full_loc: "(full_loc)", loc: "(loc)", msg: "(msg)" },
        }) do

          let(:fullmsg) { "[dt](full_loc)|(loc)|(msg)[/dt]" }

          it do
            expect(obj).to receive(:print_to_console).with(fullmsg)

            subject
          end
        end
      end
    end

    describe "function methods" do
      # TODO: Fin.
      # # Generic caller info.
      # CALLER1 = [
      #   "/path/to/project/file1.rb:201:in `meth'",
      #   "/path/to/project/file2.rb:403:in `handle_line'",
      #   "/path/to/project/file3.rb:504:in `block (2 levels) in eval'",
      # ]

      # NOTE: At least some of the function methods are usually private.
      subject { obj.send(m, *(defined?(args) ? args : [])) }

      # TODO: Organize.
      describe "#print_to_console" do
        context_when args:["smargs"] do
          it do
            subject
          end
        end
      end

      describe "#extract_file_line" do
        context_when args: ["one-two-three::"] do
          it { is_expected.to eq ["one-two-three::", "?"] }
        end

        context_when args: ["/path/to/project/file1.rb:201:in `meth'"] do
          it { is_expected.to eq ["/path/to/project/file1.rb", "201"] }
        end
      end

      describe "#format_file_rel" do
        let_a(:envi) { double("envi") }

        before :each do
          defined?(root_path) and allow(envi).to receive(:root_path).and_return(Pathname(root_path))
        end

        context_when root_path: "/some/path" do
          context_when args: ["just_a_file.rb"] do
            it { is_expected.to eq "just_a_file.rb" }
          end

          context_when args: ["/some/path/to/file.rb"] do
            it { is_expected.to eq "to/file.rb" }
          end

          context_when args: ["/some/other/file.rb"] do
            it { is_expected.to eq "../other/file.rb" }
          end
        end
      end # describe "#format_file_rel"

      describe "#format_full_loc and #format_loc" do
        let_a(:konf) { double("konf") }

        # Computation results.
        let(:full_loc) { obj.send(:format_full_loc, caller_line) }
        let(:loc) { obj.send(:format_loc, caller_line) }

        before :each do
          defined?(efl_result) and allow(obj).to receive(:extract_file_line).with(caller_line).and_return(efl_result)
          defined?(ffr_result) and allow(obj).to receive(:format_file_rel).and_return(ffr_result)

          defined?(loc_length) and allow(konf).to receive(:loc_length).and_return(loc_length)
        end

        context_when caller_line: "some-caller", efl_result: ["**", "201"], loc_length: 20 do
          context_when ffr_result: "../to/file.rb" do
            it "generally works" do
              expect(full_loc).to eq "../to/file.rb:201"
              expect(loc).to eq "   ../to/file.rb:201"
              expect(loc.length).to eq loc_length
            end
          end

          context_when ffr_result: "../to/very_long_path/extremely_long_file..rb" do
            it "generally works" do
              expect(full_loc).to eq "../to/very_long_path/extremely_long_file..rb:201"
              expect(loc).to eq "…y_long_file..rb:201"
              expect(loc.length).to eq loc_length
            end
          end
        end
      end # describe "#format_full_loc and #format_loc"

      describe "#format_msg" do
        context_when args: ["hey"] do
          it { is_expected.to eq "hey" }
        end

        context_when args: [1.5] do
          it { is_expected.to eq "1.5" }
        end

        context_when args: [{kk: "mkk"}] do
          it { is_expected.to eq "{:kk=>\"mkk\"}" }
        end
      end

      describe "#make_tokens" do
        before :each do
          expect(obj).to receive(:format_full_loc).with(args[0]).and_return("fll_signature")
          expect(obj).to receive(:format_loc).with(args[0]).and_return("fl_signature")
        end

        context_when args:["some-caller", "hey"] do
          it { is_expected.to eq({ full_loc: "fll_signature", loc: "fl_signature", msg: args[1] }) }
        end
      end
    end # describe "function methods"

    # OPTIMIZE: A few sporadic end-to-end tests.
  end # describe
end
