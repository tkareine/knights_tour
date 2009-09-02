$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

require "rubygems"

full_name = "Knight's Tour"
package_name = "knights_tour"
require "#{package_name}"
version = KnightsTour::VERSION

require "rake/clean"

require "rake/gempackagetask"
spec = Gem::Specification.new do |s|
  s.name = package_name
  s.version = version
  s.homepage = "http://github.com/tuomas/knights_tour"
  s.summary = "Solves Knight's Tour problem."
  s.description = "A program that attempts to find a solution to the Knight's Tour problem."

  s.author = "Tuomas Kareinen"
  s.email = "tkareine@gmail.com"

  s.platform = Gem::Platform::RUBY
  s.files = FileList["Rakefile", "MIT-LICENSE.txt", "*.rdoc", "bin/**/*", "lib/**/*", "spec/**/*"].to_a
  s.executables = ["knights_tour"]

  s.add_dependency("trollop", ">= 1.10.0")

  s.has_rdoc = true
  s.extra_rdoc_files = FileList["MIT-LICENSE.txt", "*.rdoc"].to_a
  s.rdoc_options << "--title"   << "#{full_name} #{version}" \
                 << "--main"    << "README.rdoc" \
                 << "--exclude" << "spec" \
                 << "--line-numbers"
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = true
end

desc "Generate a gemspec file"
task :gemspec do
  File.open("#{spec.name}.gemspec", "w") do |f|
    f.write spec.to_ruby
  end
end

task :install => [:package] do
  sh %{sudo gem install pkg/#{package_name}-#{version}.gem}
end

task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{package_name}}
end

require "rake/rdoctask"
desc "Create documentation"
Rake::RDocTask.new(:rdoc) do |rd|
  rd.rdoc_dir = "rdoc"
  rd.title = "#{full_name} #{version}"
  rd.main = "README.rdoc"
  rd.rdoc_files.include("MIT-LICENSE.txt", "*.rdoc", "lib/**/*.rb")
  rd.options << "--line-numbers"
end

require "spec/rake/spectask"
desc "Run specs"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList["spec/**/*_spec.rb"]
  t.spec_opts = ["--colour --format progress --loadby mtime"]
  t.warning = true
  t.libs << "lib"
end

desc "Run specs with RCov"
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.spec_files = FileList["spec/**/*.rb"]
  t.rcov = true
  t.rcov_opts = ["--exclude", "spec"]
  t.libs << "lib"
end

desc "Find code smells"
task :roodi do
  sh %{roodi "**/*.rb"}
end

desc "Search unfinished parts of source code"
task :todo do
  FileList["**/*.rb", "**/*.rdoc", "**/*.txt"].egrep /(TODO|FIXME)/
end

task :default => :spec
