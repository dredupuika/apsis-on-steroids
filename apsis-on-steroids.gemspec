# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: apsis-on-steroids 0.0.13 ruby lib

Gem::Specification.new do |s|
  s.name = "apsis-on-steroids"
  s.version = "0.0.13"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["kaspernj"]
  s.date = "2015-09-10"
  s.description = "A Ruby API for the Apsis mail service. "
  s.email = "k@spernj.org"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "apsis-on-steroids.gemspec",
    "include/bounce.rb",
    "include/click.rb",
    "include/errors.rb",
    "include/mailing_list.rb",
    "include/open.rb",
    "include/opt_out.rb",
    "include/sending.rb",
    "include/sub_base.rb",
    "include/subscriber.rb",
    "lib/apsis-on-steroids.rb",
    "spec/apsis-on-steroids_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/kaspernj/apsis-on-steroids"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.0"
  s.summary = "A Ruby API for the Apsis mail service."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<http2>, ["~> 0.0.31"])
      s.add_runtime_dependency(%q<string-cases>, [">= 0"])
      s.add_runtime_dependency(%q<tretry>, ["= 0.0.2"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<rubocop>, ["~> 0.34.2"])
    else
      s.add_dependency(%q<http2>, ["~> 0.0.31"])
      s.add_dependency(%q<string-cases>, [">= 0"])
      s.add_dependency(%q<tretry>, ["= 0.0.2"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<rubocop>, ["~> 0.34.2"])
    end
  else
    s.add_dependency(%q<http2>, ["~> 0.0.31"])
    s.add_dependency(%q<string-cases>, [">= 0"])
    s.add_dependency(%q<tretry>, ["= 0.0.2"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<rubocop>, ["~> 0.34.2"])
  end
end

