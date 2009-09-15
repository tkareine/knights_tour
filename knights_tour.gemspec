# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{knights_tour}
  s.version = "0.3.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tuomas Kareinen"]
  s.date = %q{2009-09-16}
  s.default_executable = %q{knights_tour}
  s.description = %q{A program that attempts to find a solution to the Knight's Tour problem.}
  s.email = %q{tkareine@gmail.com}
  s.executables = ["knights_tour"]
  s.extra_rdoc_files = ["MIT-LICENSE.txt", "CHANGELOG.rdoc", "README.rdoc"]
  s.files = ["Rakefile", "MIT-LICENSE.txt", "CHANGELOG.rdoc", "README.rdoc", "bin/knights_tour", "lib/knights_tour.rb", "spec/knights_tour_spec.rb"]
  s.homepage = %q{http://github.com/tuomas/knights_tour}
  s.rdoc_options = ["--title", "Knight's Tour 0.3.5", "--main", "README.rdoc", "--exclude", "spec", "--line-numbers"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Solves Knight's Tour problem.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<trollop>, [">= 1.10.0"])
    else
      s.add_dependency(%q<trollop>, [">= 1.10.0"])
    end
  else
    s.add_dependency(%q<trollop>, [">= 1.10.0"])
  end
end
