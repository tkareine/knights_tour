require "rubygems"

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "knights_tour"
    gem.summary = %Q{A program that attempts to find a solution to the Knight's Tour problem.}
    gem.email = "tkareine@gmail.com"
    gem.homepage = "http://github.com/tuomas/knights_tour"
    gem.authors = ["Tuomas Kareinen"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
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
