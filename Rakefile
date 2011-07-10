require "rake/rdoctask"

GEM_NAME = "rails_dt"

begin
  require "jeweler"
  Jeweler::Tasks.new do |gem|
    gem.name = GEM_NAME
    gem.summary = "Rails Debug Toolkit"
    gem.description = "Rails Debug Toolkit"
    gem.email = "alex.r@askit.org"
    gem.homepage = "http://github.com/dadooda/rails_dt"
    gem.authors = ["Alex Fortuna"]
    gem.files = FileList[
      "[A-Z]*.*",
      "*.gemspec",
      "generators/**/*",
      "lib/generators/**/*",
      "lib/**/*.rb",
      "init.rb",
    ]
  end
rescue LoadError
  STDERR.puts "This gem requires Jeweler to be built"
end

desc "Rebuild gemspec and package"
task :rebuild => [:update_generator2, :gemspec, :build]

desc "Push (publish) gem to RubyGems (aka Gemcutter)"
task :push => :rebuild do
  # Yet found no way to ask Jeweler forge a complete version string for us.
  vh = YAML.load(File.read("VERSION.yml"))
  version = [vh[:major], vh[:minor], vh[:patch]].join(".")
  pkgfile = File.join("pkg", "#{GEM_NAME}-#{version}.gem")
  system("gem", "push", pkgfile)
end

desc "Generate rdoc documentation"
Rake::RDocTask.new(:rdoc) do |rdoc|
	rdoc.rdoc_dir = "doc"
	rdoc.title    = "DT"
	#rdoc.options << "--line-numbers"
	#rdoc.options << "--inline-source"
	rdoc.rdoc_files.include("lib/**/*.rb")
end

desc "Update Rails 2 generator files with Rails 3 generator files"
task :update_generator2 do
  puts "Updating Rails 2 generator files..."
  fns = FileUtils.cp_r Dir["lib/generators/rails_dt/{USAGE,templates}"], "generators/rails_dt"
  puts ": ok (fns:#{fns.inspect})"
end

desc "Compile README preview"
task :readme do
  require "kramdown"

  doc = Kramdown::Document.new(File.read "README.md")

  fn = "README.html"
  puts "Writing '#{fn}'..."
  File.open(fn, "w") do |f|
    f.write(File.read "dev/head.html")
    f.write(doc.to_html)
  end
  puts ": ok"
end
