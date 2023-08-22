
module DY; class Instance
  describe FullMsg do
    use_letset(:let_a, :attrs)
    use_letset(:let_p, :pattrs)        # Private attributes.
    use_method_discovery :m

    let_a(:arg)
    let_a(:caller_line)
    let_a(:format)
    let_a(:loc_length)
    let_a(:root_path)

    let_p(:file)
    let_p(:file_line)
    let_p(:file_rel)
    let_p(:full_loc)
    let_p(:line)
    let_p(:loc)
    let_p(:msg)

    let(:obj) do
      described_class.new(attrs).tap do |_|
        pattrs.each { |k, v| _.send("#{k}=", v) }
      end
    end

    # NOTE: Logical order of top-level groups.

    describe "public methods" do
      subject { obj.public_send(m) }

      describe "#formatted" do
        context_when full_loc: "(fl)", loc: "(l)", msg: "(m)" do
          context_when format: "xyz" do
            it { is_expected.to eq "xyz" }
          end

          context_when format: %w[%{full_loc} %{loc} %{msg}].join("|") do
            it { is_expected.to eq [full_loc, loc, msg].join("|") }
          end
        end
      end
    end # describe "public methods"

    describe "private methods" do
      subject { obj.send(m) }

      describe "#file_line" do
        context_when caller_line: "one-two-three::" do
          it { is_expected.to eq ["one-two-three::", "?"] }
        end

        context_when caller_line: "/path/to/project/file1.rb:201:in `meth'" do
          it { is_expected.to eq ["/path/to/project/file1.rb", "201"] }
        end
      end

      describe "#file_rel" do
        context_when root_path: Pathname("/some/path") do
          context_when file_line: ["just_a_file.rb", "?"] do
            it { is_expected.to eq "just_a_file.rb" }

            context "when unknown `Pathname` exception" do
              it do
                expect(Pathname).to receive(:new).and_raise(ArgumentError, "other error")
                expect { subject }.to raise_error(ArgumentError, "other error")
              end
            end
          end

          context_when file_line: ["/some/path/to/file.rb", "?"] do
            it { is_expected.to eq "to/file.rb" }
          end

          context_when file_line: ["/some/other/file.rb", "?"] do
            it { is_expected.to eq "../other/file.rb" }
          end
        end
      end

      describe "#full_loc and #loc" do
        subject { obj }

        context_when line: 21, loc_length: 20 do
          context_when file_rel: "../to/file.rb" do
            its(:full_loc) { is_expected.to eq "../to/file.rb:21" }
            its(:loc) { is_expected.to eq "    ../to/file.rb:21" }
          end

          context_when file_rel: "../to/very_long_path/extremely_long_file..rb" do
            its(:full_loc) { is_expected.to eq "../to/very_long_path/extremely_long_file..rb:21" }
            its(:loc) { is_expected.to eq "…ly_long_file..rb:21" }
          end
        end
      end

      describe "#msg" do
        context "when no `arg`" do
          it do
            expect { subject }.to raise_error(RuntimeError, "Attribute `arg` must be set")
          end
        end

        context_when arg: nil do
          it { is_expected.to eq "nil" }
        end

        context_when arg: "hey" do
          it { is_expected.to eq "hey" }
        end

        context_when arg: 1.5 do
          it { is_expected.to eq "1.5" }
        end

        context_when arg: {kk: "mkk"} do
          it { is_expected.to eq "{:kk=>\"mkk\"}" }
        end
      end

      describe "#tokens" do
        context_when full_loc: "(fl)", loc: "(l)", msg: "(m)" do
          it { is_expected.to eq({ full_loc: full_loc, loc: loc, msg: msg }) }
        end
      end
    end # describe "private methods"

    describe "end-to-end" do
      subject { obj }

      context_when({
        arg: "Hey",
        caller_line: "/path/to/project/sub/file1.rb:21",
        format: "(DT %{loc}) %{msg}",
        loc_length: 20,
        root_path: Pathname("/path/to/project"),
      }) do
        its(:full_loc) { is_expected.to eq "sub/file1.rb:21" }
        its(:formatted) { is_expected.to eq "(DT      sub/file1.rb:21) Hey" }
      end
    end # describe "end-to-end"
  end # describe
end; end
