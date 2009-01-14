require "rubygems"
require "rake/rdoctask"
require "spec/rake/spectask"

desc "Default: execute the specs."
task :default => :spec

desc "Create documentation."
Rake::RDocTask.new(:rdoc) do |rd|
  rd.title = "Knight's Tour RDoc"
  rd.main = "README.rdoc"
  rd.rdoc_files.include("*.rdoc", "lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end

desc "Run specs."
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList["spec/**/*.rb"]
  t.spec_opts = ["--format", "specdoc"]
  #t.warning = true
end

desc "Find code smells."
task :roodi do
  sh("roodi '**/*.rb'")
end

desc "Search unfinished parts of source code."
task :todo do
  FileList["**/*.rb"].egrep /#.*(TODO|FIXME)/
end
