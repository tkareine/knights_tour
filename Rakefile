require 'rubygems'
require 'spec/rake/spectask'

desc 'Default: run specs.'
task :default => :spec

desc "Run specs."
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.spec_opts = ["--format", "specdoc"]
  #t.warning = true
end

desc "Search unfinished parts of source code."
task :todo do
  FileList['**/*.rb'].egrep /#.*(TODO|FIXME)/
end
