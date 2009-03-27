(in /Users/tuomas/Projects/knights_tour)
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{knights_tour}
  s.version = "0.2.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tuomas Kareinen"]
  s.date = %q{2009-03-28}
  s.default_executable = %q{knights_tour}
  s.description = %q{}
  s.email = %q{tkareine@gmail.com}
  s.executables = ["knights_tour"]
  s.extra_rdoc_files = ["Manifest.txt", "CHANGELOG.rdoc", "README.rdoc", "lib/knights_tour.rb"]
  s.files = ["CHANGELOG.rdoc", "Manifest.txt", "README.rdoc", "Rakefile", "bin/knights_tour", "lib/knights_tour.rb", "spec/knights_tour_spec.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/tuomas/knights_tour}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{searchable-rec}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A program that attempts to find a solution to the Knight's Tour problem.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<hoe>, [">= 1.11.0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<hoe>, [">= 1.11.0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<hoe>, [">= 1.11.0"])
  end
end
