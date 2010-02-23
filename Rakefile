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
      "lib/**/*.rb",
      "init.rb",
    ]
  end
rescue LoadError
  STDERR.puts "This gem requires Jeweler to be built"
end

desc "Rebuild gemspec and package"
task :rebuild => [:gemspec, :build]

desc "Push (publish) gem to RubyGems (aka Gemcutter)"
task :push do
  # Yet found no way to ask Jeweler forge a complete version string for us.
  vh = YAML.load(File.read("VERSION.yml"))
  version = [vh[:major], vh[:minor], vh[:patch]].join(".")
  pkgfile = File.join("pkg", [GEM_NAME, "-", version, ".gem"].to_s)
  system("gem", "push", pkgfile)
end

desc "Generate rdoc documentation"
Rake::RDocTask.new(:rdoc) do |rdoc|
	rdoc.rdoc_dir = "doc"
	rdoc.title    = "DT"
	rdoc.options << "--line-numbers"
	rdoc.options << "--inline-source"
	rdoc.rdoc_files.include("lib/**/*.rb")
end
