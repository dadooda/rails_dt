
desc "Build the gem"
task :build do
  system "gem build rails_dt.gemspec"
end

desc "Build YARD docs"
task :doc do
  system "bundle exec yard"
end

desc "Run tests"
task :test do
  system "bundle exec rspec"
end
