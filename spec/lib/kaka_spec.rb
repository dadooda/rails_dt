
# TODO: CUP!

describe "kaka" do
  it do
    ta = DT::Target::Log.new
    ta.root_path = Pathname(".")
    lgr = ta.send("logger")
    # p "lgr", lgr
    ta.print("Hee haa!")
  end
end
