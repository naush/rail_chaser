# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rail_chaser/version"

Gem::Specification.new do |s|
  s.name        = "rail_chaser"
  s.version     = RailChaser::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Li-Hsuan Lung"]
  s.email       = ["lihsuan@8thlight.com"]
  s.homepage    = "http://github.com/naush/rail_chaser"
  s.summary     = %q{A tool to determine the the minimum set of specs to run based on dependency analysis}
  s.description = %q{}

  s.add_development_dependency "rake", "0.9.2"
  s.add_development_dependency "rspec", "2.9.0"
  s.add_development_dependency "sqlite3", "1.3.5"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]
end
