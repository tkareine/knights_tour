require "rubygems"

require "hoe"
require "./lib/knights_tour"
Hoe.new("knights_tour", KnightsTour::Meta::VERSION.to_s) do |p|
  p.author = "Tuomas Kareinen"
  p.email = "tkareine@gmail.com"
  p.url = "http://github.com/tuomas/knights_tour"
  p.summary =<<-END
A program that attempts to find a solution to the Knight's Tour problem.
  END
  p.readme_file = "README.rdoc"
  p.history_file = "CHANGELOG.rdoc"
  p.extra_rdoc_files = FileList["*.rdoc", "lib/**/*.rb"]
  p.extra_dev_deps = %w(rspec)
  p.rubyforge_name = "searchable-rec"
end

require "rake/rdoctask"
require "lib/knights_tour"
desc "Create documentation."
Rake::RDocTask.new(:rdoc) do |rd|
  rd.title = "Knight's Tour #{KnightsTour::Meta::VERSION}"
  rd.main = "README.rdoc"
  rd.rdoc_files.include("*.rdoc", "lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end

require "spec/rake/spectask"
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

task :default => :spec
