
# TODO: CUP!

module DT
  describe "kaka" do
    xit do
      options = {
        # shit: "meet!",
        prefix: "fuefix!",
      }
      o = Eenst::Options::P.new(options)
      p "o.prefix", o.prefix
    end

    it do
      ee = Eenst.new
      # ee.do_p("some-caller", ["Joe", 21], prefix: "goy! ")
      # dt = ee.fn(mute: true)
      dt = ee.fn(prefix: "kk(): ")
      # p "dt", dt, dt.source_location
      dt.("some-caller", ["Moe", 32])
      # dt.("some-caller", "Moe", 32)
    end
  end
end
