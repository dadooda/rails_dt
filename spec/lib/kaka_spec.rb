
describe "kaka" do
  it do
    fm = DT::Eenst::FullMsg.new(
      caller_line: "/path/to/project/file1.rb:25",
      msg: "Hey",
      root_path: Pathname("/path/to/project"),
      loc_length: 20,
    )

    p "fm", fm
    p "fm.send(:file_line)", fm.send(:file_line)
    p "fm.send(:file_rel)", fm.send(:file_rel)
    p "fm.send(:loc)", fm.send(:loc)
    p "fm.send(:full_loc)", fm.send(:full_loc)
  end

  xit do
    ta = DT::Target::Log.new
    lg = ta.send("logger")
    p "lg", lg
  end
end
