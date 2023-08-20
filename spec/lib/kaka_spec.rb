
# TODO: CUP!

module DT
  describe do
    let(:rails) { double "rails" }

    it "`Target::Rails`" do
      allow(rails).to receive(:logger).and_return(Logger.new(STDOUT))

      trg = DY::Target::Rails.new(rails: rails)
      trg.print("hehe")
    end

    xit "`DY`" do
      p "DY.conf", DY.conf
      p "DY.conf.console", DY.conf.console
      # DY.conf.console.disable
      # DY.conf.log.disable
      p "DY.conf.console.enabled", DY.conf.console.enabled
      # DY.p("hey", [:goy, 21])
      dt = DY.fn()
      dt.("goy", [:woy, 32])
      dt.("moy")
    end

    xit "`Options::DoP` and stuff" do
      options = {
        # shit: "meet!",
        prefix: "fuefix!",
      }
      o = Instance::Options::DoP.new(options)
      p "o.prefix", o.prefix
    end

    xit "Instance#fn" do
      ee = Instance.new
      # ee.do_p("some-caller", ["Joe", 21], prefix: "goy! ")
      # dt = ee.fn(mute: true)
      # dt = ee.fn(prefix: "kk(): ")
      # p "dt", dt, dt.source_location
      # dt.("some-caller", ["Moe", 32])
      # dt.("some-caller", "Moe", 32)
    end

    xit "lambda and `caller`" do
      prn = ->(msg) do
        caller_line = caller[0]
        p "(at #{caller_line}) #{msg}"
      end

      prn.("hey")
      prn.("goy")
    end
  end
end
