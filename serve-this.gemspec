# -*- encoding: utf-8 -*-

require File.dirname(__FILE__)+'/lib/serve-this/version'

Gem::Specification.new do |s|
  s.name = %q{serve-this}
  s.version = ServeThis::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew Rudy Jacobs"]
  s.date = %q{2011-08-03}
  s.default_executable = %q{serve-this}
  s.email = %q{MatthewRudyJacobs@gmail.com}
  s.executables = ["serve-this"]
  s.extra_rdoc_files = ["README"]
  s.files = ["README", "bin/serve-this", "lib/serve-this.rb", "lib/serve-this/version.rb", "res/favicon.ico"]
  s.homepage = %q{https://github.com/matthewrudy/serve-this}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Serve files from the current directory}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 1.2.0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 1.2.0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 1.2.0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end
