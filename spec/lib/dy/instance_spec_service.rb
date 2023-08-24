
shared_examples "instance_spec_service" do
  def self.mock_conf
    p "poop!"
  end
end

module DY
  describe Instance do
    p "self", self
    # self.konst = "hehe"
    def self.konst
      "poop!"
    end


    # module Service
    #   # Mock <tt>conf.*</tt> via optional +let+ variables, e.g. `of_conf_console_enabled`.
    #   def mock_conf
    #     let(:conf) { double "conf" }
    #     let(:conf_console) { double "conf.console" }
    #     let(:conf_log) { double "conf.log" }
    #     let(:conf_rails) { double "conf.rails" }

    #     before :each do
    #       allow(conf).to receive(:console).and_return(conf_console)
    #       allow(conf).to receive(:log).and_return(conf_log)
    #       allow(conf).to receive(:rails).and_return(conf_rails)
    #       allow(conf_console).to receive(:enabled).and_return(of_conf_console_enabled) if defined?(of_conf_console_enabled)
    #       allow(conf_log).to receive(:enabled).and_return(of_conf_log_enabled) if defined?(of_conf_log_enabled)
    #       allow(conf_rails).to receive(:enabled).and_return(of_conf_rails_enabled) if defined?(of_conf_rails_enabled)
    #     end
    #   end

    #   def mock_envi
    #     before :each do
    #       allow(envi).to receive(:rails).and_return(of_envi_rails) if defined?(of_envi_rails)
    #     end
    #   end
    # end
  end # describe
end
