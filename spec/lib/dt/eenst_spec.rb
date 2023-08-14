
module DT
  describe Eenst do
    use_letset(:let_a, :attrs)
    use_method_discovery :m

    let(:obj) { described_class.new(attrs) }

    describe "public methods" do
      subject { obj.public_send(m, *(defined?(args) ? args : [])) }
    end

    describe "function methods" do
      # NOTE: At least some of the function methods are usually private.
      subject { obj.send(m, *(defined?(args) ? args : [])) }

      describe "#do_p1" do
        # NOTE: This is highly important. `conf` attribute hasn't got a default,
        #       but we use values from it here, like `obj.conf.format` and stuff.
        let_a(:conf) { Konf.new }

        context_when args: ["some-caller", "some-arg", described_class::Options::DoP.new(prefix: "pfx")] do
          let(:full_msg) { double("full_msg") }

          it "generally works" do
            expect(described_class::FullMsg).to receive(:new).with({
              arg: args[1],
              caller_line: args[0],
              format: obj.conf.format,
              loc_length: obj.conf.loc_length,
              prefix: args[2].prefix,
              root_path: obj.envi.root_path,
            }).and_return(full_msg)
            expect(full_msg).to receive(:formatted).and_return("of_fmf")

            expect(obj).to receive(:print_to_console).with("of_fmf")
            expect(obj).to receive(:print_to_log).with("of_fmf")

            subject
          end
        end
      end

      describe "`print_to_*`" do
        let_a(:conf) { double("conf") }

        describe "#print_to_console" do
          let(:conf_console) { double("conf.console") }
          let(:t_console) { double("t_console") }

          before :each do
            allow(conf).to receive(:console).and_return(conf_console)
            allow(obj).to receive(:t_console).and_return(t_console)
            defined?(of_conf_console_enabled) and allow(conf_console).to receive(:enabled).with(no_args).and_return(of_conf_console_enabled)
          end

          context_when args:["full message"] do
            context_when of_conf_console_enabled: true do
              it do
                expect(t_console).to receive(:print).with(args[0])
                subject
              end
            end

            context_when of_conf_console_enabled: false do
              it do
                expect(t_console).not_to receive(:print)
                subject
              end
            end
          end
        end # describe "#print_to_console"

        describe "#print_to_log" do
          let(:conf_log) { double("conf.log") }
          let(:t_log) { double("t_log") }

          before :each do
            allow(conf).to receive(:log).and_return(conf_log)
            allow(obj).to receive(:t_log).and_return(t_log)
            defined?(of_conf_log_enabled) and allow(conf_log).to receive(:enabled).with(no_args).and_return(of_conf_log_enabled)
          end

          context_when args:["full message"] do
            context_when of_conf_log_enabled: true do
              it do
                expect(t_log).to receive(:print).with(args[0])
                subject
              end
            end

            context_when of_conf_log_enabled: false do
              it do
                expect(t_log).not_to receive(:print)
                subject
              end
            end
          end
        end # describe "#print_to_log"
      end # describe "`print_to_*`"
    end # describe "function methods"

    # OPTIMIZE: A few sporadic end-to-end tests once everything settles nicely.
  end # describe
end
