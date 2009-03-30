require "rubygems"

require "lib/knights_tour"

require "rake/gempackagetask"
spec = Gem::Specification.new do |s|
  s.author = "Tuomas Kareinen"
  s.email = "tkareine@gmail.com"
  s.homepage = "http://github.com/tuomas/knights_tour"
  s.name = "knights_tour"
  s.version = KnightsTour::Meta::VERSION.to_s
  s.summary = "Solves Knight's Tour problem."
  s.description =<<-END
A program that attempts to find a solution to the Knight's Tour problem.
  END
  s.files = FileList["lib/**/*.rb", "bin/**/*", "*.rdoc", "spec/**/*.rb"].to_a
  s.executables << "knights_tour"
  s.add_dependency("trollop", ">= 1.10.0")
  s.add_development_dependency("rspec", ">= 1.2.0")
  s.has_rdoc = true
  s.rdoc_options << "--title" << "Knight's Tour #{s.version}" \
                 << "--main"  << "README.rdoc" \
                 << "--line-numbers"
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = true
end

require "rake/rdoctask"
desc "Create documentation"
Rake::RDocTask.new(:rdoc) do |rd|
  rd.title = "Knight's Tour #{KnightsTour::Meta::VERSION}"
  rd.main = "README.rdoc"
  rd.rdoc_files.include("*.rdoc", "lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end

require "spec/rake/spectask"
desc "Run specs"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList["spec/**/*.rb"]
  t.spec_opts = ["--format", "specdoc"]
  #t.warning = true
end

desc "Find code smells"
task :roodi do
  sh("roodi '**/*.rb'")
end

desc "Search unfinished parts of source code"
task :todo do
  FileList["**/*.rb"].egrep /#.*(TODO|FIXME)/
end

task :default => :spec
