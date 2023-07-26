
describe "kaka" do
  it do
    ta = DT::Target::Log.new
    lg = ta.send("logger")
    p "lg", lg
  end
end
