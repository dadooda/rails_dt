
# TODO: CUP!

describe "kaka" do
  xit do
    ee = DT::Eenst.new
    ee.konf.loc_length = 10
    ee.send(:_p1, "some-file.rb", "koo koo!")
  end

  it do
    ta = DT::Target::Log.new
    lg = ta.send("logger")
    p "lg", lg
  end
end
